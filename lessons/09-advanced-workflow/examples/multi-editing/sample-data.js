// マルチカーソル編集の練習用サンプルデータ

// 1. 変数名の一括変更練習
const userName = "Alice";
console.log(userName);
const userAge = 30;
function getUserName() {
  return userName;
}
const userInfo = { name: userName, age: userAge };

// 2. 関数名の統一練習
function getUserData() { return "data"; }
function getUserProfile() { return "profile"; }
function getUserSettings() { return "settings"; }
function getUserPreferences() { return "preferences"; }

// 3. 文字列の一括変更練習
const messages = [
  "Hello, welcome to our app!",
  "Hello, how can we help you?",
  "Hello, please check your settings.",
  "Hello, your profile has been updated."
];

// 4. オブジェクトプロパティの追加練習
const users = [
  { id: 1, name: "Alice" },
  { id: 2, name: "Bob" },
  { id: 3, name: "Charlie" },
  { id: 4, name: "Diana" },
  { id: 5, name: "Eve" }
];

// 5. インポート文の整理練習
import React from 'react';
import useState from 'react';
import useEffect from 'react';
import Component from './Component';
import Helper from './Helper';
import Utils from './Utils';

// 6. CSS-in-JSの練習
const styles = {
  button: { background: 'blue' },
  input: { background: 'white' },
  label: { background: 'gray' },
  form: { background: 'lightgray' },
  modal: { background: 'white' }
};

// 7. APIエンドポイントの統一練習
const API_ENDPOINTS = {
  USERS: '/api/users',
  POSTS: '/api/posts',
  COMMENTS: '/api/comments',
  CATEGORIES: '/api/categories'
};

// 8. ログメッセージの練習
console.log('Starting application...');
console.log('Loading configuration...');
console.log('Connecting to database...');
console.log('Application ready!');

// 9. 条件分岐の統一練習
if (user && user.isActive) { /* 処理1 */ }
if (user && user.isVerified) { /* 処理2 */ }
if (user && user.hasPermission) { /* 処理3 */ }
if (user && user.isLoggedIn) { /* 処理4 */ }

// 10. 配列メソッドの統一練習
const numbers = [1, 2, 3, 4, 5];
numbers.map(n => n * 2);
numbers.filter(n => n > 2);
numbers.reduce((acc, n) => acc + n, 0);
numbers.forEach(n => console.log(n));