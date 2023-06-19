window.addEventListener('load', function() {
  const approveButton = document.getElementById('approve-button');
  const reproveButton = document.getElementById('reprove-button');
  const checkboxes = document.getElementsByClassName('report-checkbox');
  const selectAllCheckbox = document.getElementById('select-all-checkbox');

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
