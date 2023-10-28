import { appQueryReducer } from "./app.query";
import { appSliceReducer } from "./app.slice";

const combineReducer = {
  ...appQueryReducer,
  ...appSliceReducer
}

export * from './app.query'
export * from './app.slice'
export default combineReducer