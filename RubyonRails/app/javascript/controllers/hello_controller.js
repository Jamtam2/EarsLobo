import { Controller } from 'stimulus'; 
  export default class extends Controller {
    connect() {
      console.log("hello from StimulusJS")
    }
    greet() {
      console.log("click")
    }
  }

