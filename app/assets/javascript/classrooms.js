window.addEventListener('load', function() {
  const selectAllCheckbox = document.getElementById('select-all-checkbox');
  const deleteSelectedBtn = document.getElementById('delete-selected-btn');
  const editButton = document.getElementById('edit-button');
  const checkboxes = document.getElementsByClassName('classroom-checkbox');

  selectAllCheckbox.addEventListener('change', function() {
    const isChecked = this.checked;

    for (let i = 0; i < checkboxes.length; i++) {
      checkboxes[i].checked = isChecked;
    }

    deleteSelectedBtn.disabled = !isChecked;
    editButton.disabled = !isChecked;
  });

  for (let i = 0; i < checkboxes.length; i++) {
    checkboxes[i].addEventListener('change', function() {
      const isAnyCheckboxSelected = Array.from(checkboxes).some(checkbox => checkbox.checked);
      deleteSelectedBtn.disabled = !isAnyCheckboxSelected;
      editButton.disabled = !isAnyCheckboxSelected;
      selectAllCheckbox.checked = isAnyCheckboxSelected && Array.from(checkboxes).every(checkbox => checkbox.checked);
    });
  }

  deleteSelectedBtn.addEventListener('click', function() {
    event.preventDefault();

    const selectedIds = Array.from(checkboxes)
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);

    if (selectedIds.length > 0) {
      const confirmDelete = confirm('Tem certeza de que deseja excluir as turmas selecionadas?');

      if (confirmDelete) {
        const deleteForm = document.getElementById('delete-form');

        selectedIds.forEach(function(classroomId) {
          const hiddenField = document.createElement('input');
          hiddenField.setAttribute('type', 'hidden');
          hiddenField.setAttribute('name', 'selected_ids[]');
          hiddenField.setAttribute('value', classroomId);
          deleteForm.appendChild(hiddenField);
        });

        deleteForm.submit();
      } else {
        return false;
      }
    } else {
      alert('Selecione pelo menos uma turma para exclusão.');
    }
  });

  editButton.addEventListener('click', function(event) {
    event.preventDefault();

    const selectedIds = Array.from(checkboxes)
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);

    if (selectedIds.length === 1) {
      const classroomId = selectedIds[0];
      window.location.href = `/classrooms/${classroomId}/edit`;
    } else {
      alert('Por favor, selecione uma única turma para editar.');
    }
  });
});
