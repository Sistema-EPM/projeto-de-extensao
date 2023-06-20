document.addEventListener('DOMContentLoaded', function() {
  const closeButtons = document.querySelectorAll('.close');

  closeButtons.forEach(function(button) {
    button.addEventListener('click', function() {
      const flashElement = this.closest('.flash');
      flashElement.remove();
    });
  });
});