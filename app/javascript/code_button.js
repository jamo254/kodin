// app/javascript/code_button.js

// Add a code block button to the Trix editor toolbar
document.addEventListener("trix-initialize", function(event) {
    // Get the editor element
    const trixEditor = event.target;
    // Get the toolbar element
    const toolbarElement = trixEditor.toolbarElement;
    
    // Create custom button HTML
    const buttonHTML = `
      <button type="button" class="trix-button" data-trix-action="code" title="Insert Code Block">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M12.316 3.051a1 1 0 01.633 1.265l-4 12a1 1 0 11-1.898-.632l4-12a1 1 0 011.265-.633zM5.707 6.293a1 1 0 010 1.414L3.414 10l2.293 2.293a1 1 0 11-1.414 1.414l-3-3a1 1 0 010-1.414l3-3a1 1 0 011.414 0zm8.586 0a1 1 0 011.414 0l3 3a1 1 0 010 1.414l-3 3a1 1 0 11-1.414-1.414L16.586 10l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
        </svg>
      </button>
    `;
    
    // Find a button group to add the code button to
    // Look for block-tools group first, otherwise use the first group
    const blockTools = toolbarElement.querySelector(".trix-button-group--block-tools") || 
                      toolbarElement.querySelector(".trix-button-group");
    
    if (blockTools) {
      // Add the button to the group
      blockTools.insertAdjacentHTML("beforeend", buttonHTML);
      
      // Get a reference to the new button
      const codeButton = blockTools.querySelector("[data-trix-action=code]");
      
      // Add an event listener to the button
      codeButton.addEventListener("click", function(event) {
        // Prevent the default action
        event.preventDefault();
        
        // Prompt the user for the programming language
        const language = prompt("Enter programming language (e.g. ruby, javascript, html, css):", "");
        
        if (language !== null) {
          // Get the selected text
          const selection = trixEditor.editor.getSelectedRange();
          const hasSelection = selection[0] !== selection[1];
          
          // Use the selected text or a placeholder
          const selectedText = hasSelection ? 
            trixEditor.editor.getSelectedText() : 
            "// Your code here";
          
          // Escape HTML entities in the selected text
          const escapedText = selectedText
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
          
          // Create the code block HTML
          const codeBlock = `<pre><code class="language-${language}">${escapedText}</code></pre>`;
          
          // Insert the code block
          trixEditor.editor.insertHTML(codeBlock);
          
          // Apply syntax highlighting with a slight delay to let the editor update
          setTimeout(() => {
            if (window.hljs) {
              const codeBlocks = trixEditor.querySelectorAll('pre code');
              codeBlocks.forEach(block => {
                try {
                  hljs.highlightElement(block);
                } catch (e) {
                  console.error('Error highlighting:', e);
                }
              });
            }
          }, 100);
        }
      });
    }
  });
  
  // Re-apply highlighting when Trix content changes
  document.addEventListener("trix-change", function(event) {
    setTimeout(() => {
      if (window.hljs) {
        const trixEditor = event.target;
        const codeBlocks = trixEditor.querySelectorAll('pre code');
        codeBlocks.forEach(block => {
          try {
            if (!block.className.includes('language-')) {
              block.classList.add('language-plaintext');
            }
            hljs.highlightElement(block);
          } catch (e) {
            console.error('Error highlighting on change:', e);
          }
        });
      }
    }, 100);
  });