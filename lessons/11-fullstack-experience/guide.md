# フルスタック開発体験 - 詳細ガイド

## フェーズ1: プロジェクト設計・セットアップ

### 1.1 要件定義・設計

#### ユーザーストーリーの作成

```markdown
# TaskFlow - ユーザーストーリー

## Epic 1: ユーザー管理
- As a user, I want to register an account so that I can access the application
- As a user, I want to login with email/password so that I can access my tasks
- As a user, I want to update my profile so that I can keep my information current

## Epic 2: プロジェクト管理
- As a user, I want to create projects so that I can organize my tasks
- As a project owner, I want to invite team members so that we can collaborate
- As a team member, I want to see my assigned tasks so that I know what to work on

## Epic 3: タスク管理
- As a user, I want to create tasks so that I can track my work
- As a user, I want to update task status so that others know my progress
- As a user, I want to comment on tasks so that I can communicate with my team

## Epic 4: リアルタイム機能
- As a user, I want to see real-time updates so that I stay informed
- As a user, I want to receive notifications so that I don't miss important updates
```

#### データベース設計

```prisma
// packages/database/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String
  avatar    String?
  role      Role     @default(USER)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // Relations
  ownedProjects    Project[]      @relation("ProjectOwner")
  projectMembers   ProjectMember[]
  assignedTasks    Task[]         @relation("TaskAssignee")
  createdTasks     Task[]         @relation("TaskCreator")
  comments         Comment[]
  notifications    Notification[]

  @@map("users")
}

model Project {
  id          String   @id @default(cuid())
  name        String
  description String?
  color       String   @default("#3B82F6")
  ownerId     String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  // Relations
  owner   User            @relation("ProjectOwner", fields: [ownerId], references: [id], onDelete: Cascade)
  members ProjectMember[]
  tasks   Task[]

  @@map("projects")
}

model ProjectMember {
  id        String    @id @default(cuid())
  projectId String
  userId    String
  role      TeamRole  @default(MEMBER)
  joinedAt  DateTime  @default(now())

  // Relations
  project Project @relation(fields: [projectId], references: [id], onDelete: Cascade)
  user    User    @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([projectId, userId])
  @@map("project_members")
}

model Task {
  id          String     @id @default(cuid())
  title       String
  description String?
  status      TaskStatus @default(TODO)
  priority    Priority   @default(MEDIUM)
  dueDate     DateTime?
  projectId   String
  assigneeId  String?
  creatorId   String
  createdAt   DateTime   @default(now())
  updatedAt   DateTime   @updatedAt

  // Relations
  project   Project   @relation(fields: [projectId], references: [id], onDelete: Cascade)
  assignee  User?     @relation("TaskAssignee", fields: [assigneeId], references: [id])
  creator   User      @relation("TaskCreator", fields: [creatorId], references: [id])
  comments  Comment[]

  @@map("tasks")
}

model Comment {
  id        String   @id @default(cuid())
  content   String
  taskId    String
  authorId  String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // Relations
  task   Task @relation(fields: [taskId], references: [id], onDelete: Cascade)
  author User @relation(fields: [authorId], references: [id], onDelete: Cascade)

  @@map("comments")
}

model Notification {
  id        String           @id @default(cuid())
  type      NotificationType
  title     String
  message   String
  isRead    Boolean          @default(false)
  userId    String
  createdAt DateTime         @default(now())

  // Relations
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("notifications")
}

// Enums
enum Role {
  USER
  ADMIN
}

enum TeamRole {
  MEMBER
  LEAD
  ADMIN
}

enum TaskStatus {
  TODO
  IN_PROGRESS
  IN_REVIEW
  DONE
}

enum Priority {
  LOW
  MEDIUM
  HIGH
  URGENT
}

enum NotificationType {
  TASK_ASSIGNED
  TASK_COMPLETED
  COMMENT_ADDED
  PROJECT_INVITATION
}
```

### 1.2 開発環境構築

#### モノレポ構成の初期化

```lua
-- TaskFlow プロジェクト作成の自動化
local function create_taskflow_project()
  local project_name = "taskflow"
  
  -- ルートディレクトリの作成
  vim.fn.mkdir(project_name, "p")
  vim.cmd("cd " .. project_name)
  
  -- ディレクトリ構造作成
  local dirs = {
    "apps/web/src/{components,pages,hooks,utils,types,contexts}",
    "apps/api/src/{controllers,routes,middleware,services,utils,types}",
    "packages/shared/src",
    "packages/database/prisma",
    "packages/config",
    "tools/{eslint-config,deployment}",
    "docs",
    ".github/workflows"
  }
  
  for _, dir in ipairs(dirs) do
    vim.fn.mkdir(dir, "p")
  end
  
  -- package.json (root)
  local root_package = {
    name = "taskflow",
    version = "1.0.0",
    private = true,
    workspaces = { "apps/*", "packages/*" },
    scripts = {
      dev = "concurrently \"npm run dev:web\" \"npm run dev:api\"",
      ["dev:web"] = "cd apps/web && npm run dev",
      ["dev:api"] = "cd apps/api && npm run dev",
      build = "npm run build:web && npm run build:api",
      ["build:web"] = "cd apps/web && npm run build",
      ["build:api"] = "cd apps/api && npm run build",
      test = "npm run test:web && npm run test:api",
      ["test:web"] = "cd apps/web && npm test",
      ["test:api"] = "cd apps/api && npm test",
      lint = "eslint . --ext .ts,.tsx,.js,.jsx",
      ["lint:fix"] = "eslint . --ext .ts,.tsx,.js,.jsx --fix",
      typecheck = "tsc --noEmit",
      prepare = "husky install"
    },
    devDependencies = {
      concurrently = "^8.2.0",
      husky = "^8.0.3",
      ["lint-staged"] = "^13.2.0",
      typescript = "^5.0.0"
    }
  }
  
  vim.fn.writefile(
    vim.split(vim.fn.json_encode(root_package), "\n"),
    "package.json"
  )
  
  -- プロジェクト固有のNeovim設定
  local nvim_config = [[
-- TaskFlow プロジェクト設定

-- ワークスペース管理
vim.keymap.set("n", "<leader>pw", "<cmd>cd apps/web<cr>", { desc = "Switch to Web App" })
vim.keymap.set("n", "<leader>pa", "<cmd>cd apps/api<cr>", { desc = "Switch to API" })
vim.keymap.set("n", "<leader>pr", function() vim.cmd("cd " .. vim.fn.expand("~/dev/taskflow")) end, { desc = "Return to Root" })

-- 開発サーバー操作
vim.keymap.set("n", "<leader>ds", "<cmd>!npm run dev<cr>", { desc = "Start All Servers" })
vim.keymap.set("n", "<leader>dw", "<cmd>!npm run dev:web<cr>", { desc = "Start Web Server" })
vim.keymap.set("n", "<leader>da", "<cmd>!npm run dev:api<cr>", { desc = "Start API Server" })

-- データベース操作
vim.keymap.set("n", "<leader>dm", "<cmd>!cd packages/database && npx prisma migrate dev<cr>", { desc = "Run Migrations" })
vim.keymap.set("n", "<leader>dg", "<cmd>!cd packages/database && npx prisma generate<cr>", { desc = "Generate Prisma Client" })
vim.keymap.set("n", "<leader>ds", "<cmd>!cd packages/database && npx prisma studio<cr>", { desc = "Open Prisma Studio" })

-- テスト・ビルド
vim.keymap.set("n", "<leader>tt", "<cmd>!npm test<cr>", { desc = "Run All Tests" })
vim.keymap.set("n", "<leader>tw", "<cmd>!npm run test:web<cr>", { desc = "Test Web" })
vim.keymap.set("n", "<leader>ta", "<cmd>!npm run test:api<cr>", { desc = "Test API" })
vim.keymap.set("n", "<leader>bb", "<cmd>!npm run build<cr>", { desc = "Build All" })

-- コード品質
vim.keymap.set("n", "<leader>lf", "<cmd>!npm run lint:fix<cr>", { desc = "Fix Lint Issues" })
vim.keymap.set("n", "<leader>tc", "<cmd>!npm run typecheck<cr>", { desc = "TypeScript Check" })

print("TaskFlow development environment loaded!")
]]
  
  vim.fn.writefile(vim.split(nvim_config, "\n"), ".nvim.lua")
  
  -- README作成
  local readme = string.format([[
# TaskFlow - Team Task Management App

A modern, full-stack task management application built with Next.js, Express, and TypeScript.

## 🚀 Quick Start

1. Install dependencies:
```bash
npm install
```

2. Setup database:
```bash
cd packages/database
npx prisma migrate dev
npx prisma generate
```

3. Start development servers:
```bash
npm run dev
```

## 📁 Project Structure

- `apps/web/` - Next.js frontend application
- `apps/api/` - Express.js API server
- `packages/shared/` - Shared types and utilities
- `packages/database/` - Prisma database configuration

## 🛠 Development

### Available Scripts

- `npm run dev` - Start both web and API servers
- `npm run build` - Build both applications
- `npm run test` - Run all tests
- `npm run lint` - Lint all code
- `npm run typecheck` - Run TypeScript compiler check

### Development Workflow

1. Create feature branch: `git checkout -b feature/task-management`
2. Make changes and test locally
3. Run tests: `npm test`
4. Commit changes: `git commit -m "feat: add task management"`
5. Push and create PR: `git push origin feature/task-management`

## 🚀 Deployment

- Frontend: Deployed to Vercel
- Backend: Deployed to Railway
- Database: PostgreSQL on Railway

## 📚 Documentation

- [Development Guide](./docs/development.md)
- [API Documentation](./docs/api.md)
- [Deployment Guide](./docs/deployment.md)
]])
  
  vim.fn.writefile(vim.split(readme, "\n"), "README.md")
  
  vim.cmd("edit README.md")
  print("TaskFlow project created successfully!")
end

vim.keymap.set("n", "<leader>ct", create_taskflow_project, { desc = "Create TaskFlow Project" })
```

## フェーズ2: コア機能開発

### 2.1 認証システム構築

#### NextAuth.js統合認証

```typescript
// apps/web/src/lib/auth.ts
import { NextAuthOptions } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import { PrismaAdapter } from "@next-auth/prisma-adapter";
import { prisma } from "@taskflow/database";
import bcrypt from "bcryptjs";

export const authOptions: NextAuthOptions = {
  adapter: PrismaAdapter(prisma),
  providers: [
    CredentialsProvider({
      name: "credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          return null;
        }

        const user = await prisma.user.findUnique({
          where: { email: credentials.email }
        });

        if (!user) {
          return null;
        }

        const isPasswordValid = await bcrypt.compare(
          credentials.password,
          user.password
        );

        if (!isPasswordValid) {
          return null;
        }

        return {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
        };
      }
    })
  ],
  session: {
    strategy: "jwt",
    maxAge: 30 * 24 * 60 * 60, // 30 days
  },
  jwt: {
    maxAge: 30 * 24 * 60 * 60, // 30 days
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role;
      }
      return token;
    },
    async session({ session, token }) {
      if (token) {
        session.user.id = token.sub!;
        session.user.role = token.role;
      }
      return session;
    },
  },
  pages: {
    signIn: "/auth/signin",
    signUp: "/auth/signup",
  },
};
```

#### 認証フロー UI

```typescript
// apps/web/src/components/auth/SignInForm.tsx
import React, { useState } from 'react';
import { signIn } from 'next-auth/react';
import { useRouter } from 'next/router';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export const SignInForm: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');

    const result = await signIn('credentials', {
      email,
      password,
      redirect: false,
    });

    if (result?.error) {
      setError('Invalid email or password');
    } else {
      router.push('/dashboard');
    }

    setIsLoading(false);
  };

  return (
    <Card className="w-full max-w-md mx-auto">
      <CardHeader>
        <CardTitle>Sign In to TaskFlow</CardTitle>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="email">Email</Label>
            <Input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="password">Password</Label>
            <Input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          {error && (
            <div className="text-red-600 text-sm">{error}</div>
          )}
          <Button 
            type="submit" 
            className="w-full" 
            disabled={isLoading}
          >
            {isLoading ? 'Signing in...' : 'Sign In'}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
};
```

### 2.2 データベース・API開発

#### API Controllers

```typescript
// apps/api/src/controllers/TaskController.ts
import { Request, Response, NextFunction } from 'express';
import { prisma } from '@taskflow/database';
import { CreateTaskDto, UpdateTaskDto } from '@taskflow/shared';
import { AppError } from '../utils/AppError';

export class TaskController {
  async getTasks(req: Request, res: Response, next: NextFunction) {
    try {
      const { projectId } = req.params;
      const userId = req.user?.id;

      // ユーザーがプロジェクトのメンバーかチェック
      const projectMember = await prisma.projectMember.findFirst({
        where: {
          projectId,
          userId,
        },
      });

      if (!projectMember) {
        throw new AppError(403, 'You do not have access to this project');
      }

      const tasks = await prisma.task.findMany({
        where: { projectId },
        include: {
          assignee: {
            select: {
              id: true,
              name: true,
              email: true,
              avatar: true,
            },
          },
          creator: {
            select: {
              id: true,
              name: true,
            },
          },
          _count: {
            select: {
              comments: true,
            },
          },
        },
        orderBy: [
          { priority: 'desc' },
          { createdAt: 'desc' },
        ],
      });

      res.json({ data: tasks });
    } catch (error) {
      next(error);
    }
  }

  async createTask(req: Request, res: Response, next: NextFunction) {
    try {
      const { projectId } = req.params;
      const userId = req.user?.id;
      const createTaskDto: CreateTaskDto = req.body;

      // バリデーション
      if (!createTaskDto.title?.trim()) {
        throw new AppError(400, 'Task title is required');
      }

      // プロジェクトアクセス権チェック
      const projectMember = await prisma.projectMember.findFirst({
        where: {
          projectId,
          userId,
        },
      });

      if (!projectMember) {
        throw new AppError(403, 'You do not have access to this project');
      }

      // 担当者が有効かチェック
      if (createTaskDto.assigneeId) {
        const assignee = await prisma.projectMember.findFirst({
          where: {
            projectId,
            userId: createTaskDto.assigneeId,
          },
        });

        if (!assignee) {
          throw new AppError(400, 'Assignee is not a member of this project');
        }
      }

      const task = await prisma.task.create({
        data: {
          title: createTaskDto.title,
          description: createTaskDto.description,
          priority: createTaskDto.priority || 'MEDIUM',
          dueDate: createTaskDto.dueDate ? new Date(createTaskDto.dueDate) : null,
          projectId,
          assigneeId: createTaskDto.assigneeId,
          creatorId: userId!,
        },
        include: {
          assignee: {
            select: {
              id: true,
              name: true,
              email: true,
              avatar: true,
            },
          },
          creator: {
            select: {
              id: true,
              name: true,
            },
          },
        },
      });

      // リアルタイム通知の送信
      req.io?.to(`project:${projectId}`).emit('task:created', task);

      res.status(201).json({ data: task });
    } catch (error) {
      next(error);
    }
  }

  async updateTask(req: Request, res: Response, next: NextFunction) {
    try {
      const { taskId } = req.params;
      const userId = req.user?.id;
      const updateTaskDto: UpdateTaskDto = req.body;

      // タスクの存在確認とアクセス権チェック
      const task = await prisma.task.findFirst({
        where: {
          id: taskId,
          project: {
            members: {
              some: {
                userId,
              },
            },
          },
        },
        include: {
          project: true,
        },
      });

      if (!task) {
        throw new AppError(404, 'Task not found or access denied');
      }

      // 担当者変更時のバリデーション
      if (updateTaskDto.assigneeId && updateTaskDto.assigneeId !== task.assigneeId) {
        const assignee = await prisma.projectMember.findFirst({
          where: {
            projectId: task.projectId,
            userId: updateTaskDto.assigneeId,
          },
        });

        if (!assignee) {
          throw new AppError(400, 'Assignee is not a member of this project');
        }
      }

      const updatedTask = await prisma.task.update({
        where: { id: taskId },
        data: {
          ...(updateTaskDto.title && { title: updateTaskDto.title }),
          ...(updateTaskDto.description !== undefined && { description: updateTaskDto.description }),
          ...(updateTaskDto.status && { status: updateTaskDto.status }),
          ...(updateTaskDto.priority && { priority: updateTaskDto.priority }),
          ...(updateTaskDto.dueDate !== undefined && { 
            dueDate: updateTaskDto.dueDate ? new Date(updateTaskDto.dueDate) : null 
          }),
          ...(updateTaskDto.assigneeId !== undefined && { assigneeId: updateTaskDto.assigneeId }),
        },
        include: {
          assignee: {
            select: {
              id: true,
              name: true,
              email: true,
              avatar: true,
            },
          },
          creator: {
            select: {
              id: true,
              name: true,
            },
          },
        },
      });

      // リアルタイム更新通知
      req.io?.to(`project:${task.projectId}`).emit('task:updated', updatedTask);

      res.json({ data: updatedTask });
    } catch (error) {
      next(error);
    }
  }

  async deleteTask(req: Request, res: Response, next: NextFunction) {
    try {
      const { taskId } = req.params;
      const userId = req.user?.id;

      // タスクの存在確認とアクセス権チェック
      const task = await prisma.task.findFirst({
        where: {
          id: taskId,
          OR: [
            { creatorId: userId }, // 作成者
            {
              project: {
                ownerId: userId, // プロジェクトオーナー
              },
            },
            {
              project: {
                members: {
                  some: {
                    userId,
                    role: 'ADMIN', // プロジェクト管理者
                  },
                },
              },
            },
          ],
        },
        include: {
          project: true,
        },
      });

      if (!task) {
        throw new AppError(404, 'Task not found or insufficient permissions');
      }

      await prisma.task.delete({
        where: { id: taskId },
      });

      // リアルタイム削除通知
      req.io?.to(`project:${task.projectId}`).emit('task:deleted', { taskId });

      res.status(204).send();
    } catch (error) {
      next(error);
    }
  }
}

export const taskController = new TaskController();
```

### 2.3 フロントエンド開発

#### React Query を使用したデータ管理

```typescript
// apps/web/src/hooks/useTasks.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Task, CreateTaskDto, UpdateTaskDto } from '@taskflow/shared';
import { api } from '@/lib/api';

export const useTasks = (projectId: string) => {
  return useQuery({
    queryKey: ['tasks', projectId],
    queryFn: () => api.get<Task[]>(`/projects/${projectId}/tasks`),
    enabled: !!projectId,
  });
};

export const useCreateTask = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ projectId, data }: { projectId: string; data: CreateTaskDto }) =>
      api.post<Task>(`/projects/${projectId}/tasks`, data),
    onSuccess: (task, { projectId }) => {
      queryClient.setQueryData(['tasks', projectId], (oldTasks: Task[] = []) => [
        ...oldTasks,
        task,
      ]);
    },
  });
};

export const useUpdateTask = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ taskId, data }: { taskId: string; data: UpdateTaskDto }) =>
      api.patch<Task>(`/tasks/${taskId}`, data),
    onSuccess: (updatedTask) => {
      // 関連するクエリを更新
      queryClient.setQueryData(['tasks', updatedTask.projectId], (oldTasks: Task[] = []) =>
        oldTasks.map((task) => (task.id === updatedTask.id ? updatedTask : task))
      );
    },
  });
};
```

#### タスク管理UI

```typescript
// apps/web/src/components/tasks/TaskBoard.tsx
import React, { useState } from 'react';
import { DragDropContext, Droppable, Draggable, DropResult } from 'react-beautiful-dnd';
import { TaskStatus } from '@taskflow/shared';
import { useTasks, useUpdateTask } from '@/hooks/useTasks';
import { TaskCard } from './TaskCard';
import { CreateTaskModal } from './CreateTaskModal';
import { Button } from '@/components/ui/button';
import { Plus } from 'lucide-react';

interface TaskBoardProps {
  projectId: string;
}

const COLUMNS = [
  { id: 'TODO', title: 'To Do', color: 'bg-gray-100' },
  { id: 'IN_PROGRESS', title: 'In Progress', color: 'bg-blue-100' },
  { id: 'IN_REVIEW', title: 'In Review', color: 'bg-yellow-100' },
  { id: 'DONE', title: 'Done', color: 'bg-green-100' },
] as const;

export const TaskBoard: React.FC<TaskBoardProps> = ({ projectId }) => {
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const { data: tasks = [], isLoading } = useTasks(projectId);
  const updateTaskMutation = useUpdateTask();

  const handleDragEnd = (result: DropResult) => {
    const { destination, source, draggableId } = result;

    if (!destination) return;

    if (
      destination.droppableId === source.droppableId &&
      destination.index === source.index
    ) {
      return;
    }

    const newStatus = destination.droppableId as TaskStatus;
    updateTaskMutation.mutate({
      taskId: draggableId,
      data: { status: newStatus },
    });
  };

  const getTasksByStatus = (status: TaskStatus) => {
    return tasks.filter((task) => task.status === status);
  };

  if (isLoading) {
    return <div className="flex justify-center p-8">Loading tasks...</div>;
  }

  return (
    <div className="h-full flex flex-col">
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold">Task Board</h2>
        <Button onClick={() => setIsCreateModalOpen(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Create Task
        </Button>
      </div>

      <DragDropContext onDragEnd={handleDragEnd}>
        <div className="flex gap-6 flex-1 overflow-x-auto">
          {COLUMNS.map((column) => {
            const columnTasks = getTasksByStatus(column.id);

            return (
              <div key={column.id} className="flex-1 min-w-80">
                <div className={`${column.color} rounded-lg p-4 mb-4`}>
                  <h3 className="font-semibold text-lg">{column.title}</h3>
                  <span className="text-sm text-gray-600">
                    {columnTasks.length} tasks
                  </span>
                </div>

                <Droppable droppableId={column.id}>
                  {(provided, snapshot) => (
                    <div
                      ref={provided.innerRef}
                      {...provided.droppableProps}
                      className={`space-y-3 min-h-96 p-2 rounded-lg transition-colors ${
                        snapshot.isDraggingOver ? 'bg-gray-50' : ''
                      }`}
                    >
                      {columnTasks.map((task, index) => (
                        <Draggable
                          key={task.id}
                          draggableId={task.id}
                          index={index}
                        >
                          {(provided, snapshot) => (
                            <div
                              ref={provided.innerRef}
                              {...provided.draggableProps}
                              {...provided.dragHandleProps}
                              className={snapshot.isDragging ? 'opacity-50' : ''}
                            >
                              <TaskCard task={task} />
                            </div>
                          )}
                        </Draggable>
                      ))}
                      {provided.placeholder}
                    </div>
                  )}
                </Droppable>
              </div>
            );
          })}
        </div>
      </DragDropContext>

      <CreateTaskModal
        projectId={projectId}
        isOpen={isCreateModalOpen}
        onClose={() => setIsCreateModalOpen(false)}
      />
    </div>
  );
};
```

## フェーズ3: 高度機能・統合

### 3.1 リアルタイム機能

#### Socket.io統合

```typescript
// apps/api/src/services/SocketService.ts
import { Server } from 'socket.io';
import { verifyJWT } from '../middleware/auth';
import { prisma } from '@taskflow/database';

export class SocketService {
  private io: Server;

  constructor(io: Server) {
    this.io = io;
    this.setupMiddleware();
    this.setupEventHandlers();
  }

  private setupMiddleware() {
    this.io.use(async (socket, next) => {
      try {
        const token = socket.handshake.auth.token;
        const decoded = verifyJWT(token);
        
        const user = await prisma.user.findUnique({
          where: { id: decoded.userId },
        });

        if (!user) {
          return next(new Error('User not found'));
        }

        socket.userId = user.id;
        socket.user = user;
        next();
      } catch (error) {
        next(new Error('Authentication failed'));
      }
    });
  }

  private setupEventHandlers() {
    this.io.on('connection', (socket) => {
      console.log(`User ${socket.user.name} connected`);

      // プロジェクトルームに参加
      socket.on('join:project', async (projectId: string) => {
        // ユーザーがプロジェクトのメンバーかチェック
        const membership = await prisma.projectMember.findFirst({
          where: {
            projectId,
            userId: socket.userId,
          },
        });

        if (membership) {
          socket.join(`project:${projectId}`);
          socket.emit('joined:project', projectId);
          
          // 他のメンバーに参加を通知
          socket.to(`project:${projectId}`).emit('user:joined', {
            userId: socket.userId,
            userName: socket.user.name,
          });
        }
      });

      // プロジェクトルームから退出
      socket.on('leave:project', (projectId: string) => {
        socket.leave(`project:${projectId}`);
        socket.to(`project:${projectId}`).emit('user:left', {
          userId: socket.userId,
          userName: socket.user.name,
        });
      });

      // タスク状態のリアルタイム更新
      socket.on('task:status_change', async (data: {
        taskId: string;
        status: TaskStatus;
        projectId: string;
      }) => {
        // タスクの更新権限をチェック
        const task = await prisma.task.findFirst({
          where: {
            id: data.taskId,
            project: {
              members: {
                some: {
                  userId: socket.userId,
                },
              },
            },
          },
        });

        if (task) {
          // プロジェクトメンバーに更新を通知
          socket.to(`project:${data.projectId}`).emit('task:updated', {
            taskId: data.taskId,
            status: data.status,
            updatedBy: socket.user.name,
          });
        }
      });

      // 入力状態の通知（誰かがタイピング中）
      socket.on('typing:start', (data: { taskId: string; projectId: string }) => {
        socket.to(`project:${data.projectId}`).emit('typing:start', {
          taskId: data.taskId,
          userId: socket.userId,
          userName: socket.user.name,
        });
      });

      socket.on('typing:stop', (data: { taskId: string; projectId: string }) => {
        socket.to(`project:${data.projectId}`).emit('typing:stop', {
          taskId: data.taskId,
          userId: socket.userId,
        });
      });

      // 切断時の処理
      socket.on('disconnect', () => {
        console.log(`User ${socket.user.name} disconnected`);
      });
    });
  }

  // 通知の送信
  public sendNotification(userId: string, notification: any) {
    this.io.to(userId).emit('notification', notification);
  }

  // プロジェクト全体への通知
  public notifyProject(projectId: string, event: string, data: any) {
    this.io.to(`project:${projectId}`).emit(event, data);
  }
}
```

### 3.2 テスト・品質保証

#### E2Eテスト（Playwright）

```typescript
// apps/web/tests/task-management.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Task Management', () => {
  test.beforeEach(async ({ page }) => {
    // テスト用のユーザーでログイン
    await page.goto('/auth/signin');
    await page.fill('[data-testid=email]', 'test@example.com');
    await page.fill('[data-testid=password]', 'password123');
    await page.click('[data-testid=signin-button]');
    await page.waitForURL('/dashboard');
  });

  test('should create a new task', async ({ page }) => {
    // プロジェクトページに移動
    await page.click('[data-testid=project-link]');
    await page.waitForURL('/projects/*');

    // タスク作成モーダルを開く
    await page.click('[data-testid=create-task-button]');
    await expect(page.locator('[data-testid=create-task-modal]')).toBeVisible();

    // タスク情報を入力
    await page.fill('[data-testid=task-title]', 'Test Task');
    await page.fill('[data-testid=task-description]', 'This is a test task');
    await page.selectOption('[data-testid=task-priority]', 'HIGH');

    // タスクを作成
    await page.click('[data-testid=create-task-submit]');

    // タスクが作成されたことを確認
    await expect(page.locator('[data-testid=task-card]')).toContainText('Test Task');
  });

  test('should move task between columns', async ({ page }) => {
    await page.goto('/projects/test-project-id');
    
    // タスクをドラッグ&ドロップで移動
    const taskCard = page.locator('[data-testid=task-card]').first();
    const inProgressColumn = page.locator('[data-testid=column-IN_PROGRESS]');
    
    await taskCard.dragTo(inProgressColumn);
    
    // タスクが正しい列に移動したことを確認
    await expect(inProgressColumn.locator('[data-testid=task-card]')).toContainText('Test Task');
  });

  test('should show real-time updates', async ({ page, context }) => {
    // 2つのページを開いて同じプロジェクトを表示
    const page2 = await context.newPage();
    
    await page.goto('/projects/test-project-id');
    await page2.goto('/projects/test-project-id');
    
    // 最初のページでタスクを作成
    await page.click('[data-testid=create-task-button]');
    await page.fill('[data-testid=task-title]', 'Real-time Task');
    await page.click('[data-testid=create-task-submit]');
    
    // 2番目のページでリアルタイム更新を確認
    await expect(page2.locator('[data-testid=task-card]')).toContainText('Real-time Task');
  });
});
```

## フェーズ4: デプロイ・運用

### 4.1 CI/CDパイプライン

#### GitHub Actions ワークフロー

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '18'

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run ESLint
        run: npm run lint
      
      - name: Run TypeScript check
        run: npm run typecheck

  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: password
          POSTGRES_DB: taskflow_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Setup test database
        run: |
          cd packages/database
          npx prisma generate
          npx prisma db push
        env:
          DATABASE_URL: postgresql://postgres:password@localhost:5432/taskflow_test
      
      - name: Run unit tests
        run: npm run test:unit
        env:
          DATABASE_URL: postgresql://postgres:password@localhost:5432/taskflow_test
      
      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://postgres:password@localhost:5432/taskflow_test

  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright
        run: npx playwright install --with-deps
      
      - name: Build applications
        run: npm run build
      
      - name: Run E2E tests
        run: npm run test:e2e

  deploy-api:
    needs: [lint, test, e2e]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Railway
        uses: railway-cli/railway-action@v1
        with:
          command: 'railway up'
          api-token: ${{ secrets.RAILWAY_TOKEN }}
          project-id: ${{ secrets.RAILWAY_PROJECT_ID }}

  deploy-web:
    needs: [lint, test, e2e]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

### 4.2 本番デプロイ・監視

#### エラー監視（Sentry）

```typescript
// apps/web/src/lib/sentry.ts
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
  debug: process.env.NODE_ENV === 'development',
  beforeSend: (event) => {
    // 機密情報のフィルタリング
    if (event.request?.headers) {
      delete event.request.headers.authorization;
      delete event.request.headers.cookie;
    }
    return event;
  },
});

// カスタムエラー報告
export const reportError = (error: Error, context?: Record<string, any>) => {
  Sentry.withScope((scope) => {
    if (context) {
      scope.setContext('additional_info', context);
    }
    Sentry.captureException(error);
  });
};
```

#### パフォーマンス監視

```typescript
// apps/web/src/lib/analytics.ts
import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals';

export const initAnalytics = () => {
  // Web Vitals の測定
  getCLS(sendToAnalytics);
  getFID(sendToAnalytics);
  getFCP(sendToAnalytics);
  getLCP(sendToAnalytics);
  getTTFB(sendToAnalytics);
};

const sendToAnalytics = (metric: any) => {
  // アナリティクスサービスに送信
  if (typeof window !== 'undefined' && window.gtag) {
    window.gtag('event', metric.name, {
      event_category: 'Web Vitals',
      event_label: metric.id,
      value: Math.round(metric.name === 'CLS' ? metric.value * 1000 : metric.value),
      non_interaction: true,
    });
  }

  // カスタムアナリティクス
  fetch('/api/analytics', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      name: metric.name,
      value: metric.value,
      id: metric.id,
      navigationType: metric.navigationType,
    }),
  }).catch(console.error);
};
```

## まとめ

このフルスタック開発体験により以下を達成できます：

### 🎯 実践的スキルの習得
- **完全な開発サイクル**: 企画 → 開発 → テスト → デプロイ → 運用
- **LazyVim統合ワークフロー**: 効率的な開発環境の実践活用
- **モダンな技術スタック**: 業界標準の技術を使った実装経験

### 🚀 プロフェッショナルレベルの成果
- **実動するWebアプリケーション**: ポートフォリオとして活用可能
- **高品質なコードベース**: テスト・型安全性・パフォーマンス最適化
- **スケーラブルなアーキテクチャ**: 実際のプロダクト開発に応用可能

### 💼 キャリア活用
- **転職・フリーランス**: 実績としてアピール可能な成果物
- **チーム開発**: リードエンジニアとしてのワークフロー経験
- **継続的改善**: 実際のユーザーフィードバックを活用した改善サイクル

LazyVim学習の集大成として、プロフェッショナルな開発者への成長を実現します。