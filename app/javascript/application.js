// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
import "./controllers" 

import { Application } from "@hotwired/stimulus"

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }

import "trix"
import "@rails/actiontext" 

import "./code_button"  // Add this line

// Make sure hljs is available
if (window.hljs) {
    console.log("highlight.js loaded");
  } else {
    console.error("highlight.js not loaded");
  }
  
  // Initialize highlighting when the page loads
  document.addEventListener("turbo:load", function() {
    console.log("turbo:load event - highlighting code blocks");
    if (window.hljs) {
      document.querySelectorAll('pre code').forEach((block) => {
        console.log("Highlighting block:", block);
        hljs.highlightElement(block);
      });
    }
  });