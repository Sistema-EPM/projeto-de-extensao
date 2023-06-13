document.addEventListener('DOMContentLoaded', function() {
  const selectAllCheckbox = document.getElementById('select-all-checkbox');
  const deleteSelectedBtn = document.getElementById('delete-selected-btn');
  const editButton = document.getElementById('edit-button');
  const checkboxes = document.getElementsByClassName('student-checkbox');

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
    const selectedIds = Array.from(checkboxes)
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);

    if (selectedIds.length > 0) {
      const confirmDelete = confirm('Tem certeza de que deseja excluir os alunos selecionados?');

      if (confirmDelete) {
        const deleteForm = document.getElementById('delete-form');

        selectedIds.forEach(function(studentId) {
          const hiddenField = document.createElement('input');
          hiddenField.setAttribute('type', 'hidden');
          hiddenField.setAttribute('name', 'selected_ids[]');
          hiddenField.setAttribute('value', studentId);
          deleteForm.appendChild(hiddenField);
        });

        deleteForm.submit();
      }
    }
  });

  editButton.addEventListener('click', function(event) {
    event.preventDefault();

    const selectedIds = Array.from(checkboxes)
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);

    if (selectedIds.length === 1) {
      const studentId = selectedIds[0];
      window.location.href = `/users/${studentId}/edit`;
    } else {
      alert('Por favor, selecione um único aluno para editar.');
    }
  });
});
