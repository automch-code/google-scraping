import { combineReducers } from "@reduxjs/toolkit";
import appApiReducer from './App'

export const combinedReducer = combineReducers({
  ...appApiReducer
})
