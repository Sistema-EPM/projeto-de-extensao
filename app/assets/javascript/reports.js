window.addEventListener('load', function() {
  const approveButton = document.getElementById('approve-button');
  const reproveButton = document.getElementById('reprove-button');
  const checkboxes = document.getElementsByClassName('report-checkbox');
  const selectAllCheckbox = document.getElementById('select-all-checkbox');
  const deleteSelectedBtn = document.getElementById('delete-selected-btn');
  const editButton = document.getElementById('edit-button');

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
      const confirmDelete = confirm('Tem certeza de que deseja excluir os reportes selecionados?');

      if (confirmDelete) {
        const deleteForm = document.getElementById('delete-form');

        selectedIds.forEach(function(reportId) {
          const hiddenField = document.createElement('input');
          hiddenField.setAttribute('type', 'hidden');
          hiddenField.setAttribute('name', 'selected_ids[]');
          hiddenField.setAttribute('value', reportId);
          deleteForm.appendChild(hiddenField);
        });

        deleteForm.submit();
      } else {
        return false;
      }
    } else {
      alert('Selecione pelo menos um reporte para exclusão.');
    }
  });

  editButton.addEventListener('click', function(event) {
    event.preventDefault();

    const selectedIds = Array.from(checkboxes)
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);

    if (selectedIds.length === 1) {
      const reportId = selectedIds[0];
      window.location.href = `/reports/${reportId}/edit`;
    } else {
      alert('Por favor, selecione um único reporte para editar.');
    }
  });

  approveButton.addEventListener('click', function(event) {
    event.preventDefault();

    const selectedIds = Array.from(checkboxes)
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);

    if (selectedIds.length > 0) {
      fetch('/approve_reports', {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ selected_ids: selectedIds })
      })
      .then(response => {
        if (response.ok) {
          selectedIds.forEach(id => {
            const reportRow = document.getElementById(`report-${id}`);
            const statusCell = reportRow.querySelector('td:nth-child(4)');
            statusCell.textContent = 'Aprovado';
          });
          alert('Reportes aprovados com sucesso.');
        } else {
          response.text().then(errorMsg => {
            console.error('Erro ao aprovar os reportes:', errorMsg);
            alert('Ocorreu um erro ao aprovar os reportes. Consulte o console para mais detalhes.');
          });
        }
      })
      .catch(error => {
        console.error('Erro:', error);
        alert('Ocorreu um erro ao aprovar os reportes. Consulte o console para mais detalhes.');
      });
    } else {
      alert('Por favor, selecione pelo menos um relatório para aprovar.');
    }
  });

  reproveButton.addEventListener('click', function(event) {
    event.preventDefault();

    const selectedIds = Array.from(checkboxes)
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);

    if (selectedIds.length > 0) {
      fetch('/reprove_reports', {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ selected_ids: selectedIds })
      })
      .then(response => {
        if (response.ok) {
          selectedIds.forEach(id => {
            const reportRow = document.getElementById(`report-${id}`);
            const statusCell = reportRow.querySelector('td:nth-child(4)');
            statusCell.textContent = 'Reprovado';
          });
          alert('Reportes reprovados com sucesso.');
        } else {
          response.text().then(errorMsg => {
            console.error('Erro ao reprovar os reportes:', errorMsg);
            alert('Ocorreu um erro ao reprovar os reportes. Consulte o console para mais detalhes.');
          });
        }
      })
      .catch(error => {
        console.error('Erro:', error);
        alert('Ocorreu um erro ao reprovar os reportes. Consulte o console para mais detalhes.');
      });
    } else {
      alert('Por favor, selecione pelo menos um relatório para reprovar.');
    }
  });

  selectAllCheckbox.addEventListener('change', function() {
    const isChecked = selectAllCheckbox.checked;
    Array.from(checkboxes).forEach(checkbox => {
      checkbox.checked = isChecked;
    });
  });

});
