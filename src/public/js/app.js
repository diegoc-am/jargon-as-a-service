const urls = {
    fetchNo: '/api/phrases/no/sample',
    fetchYes: '/api/phrases/yes/sample',
    fetchExecutiveCoercion: '/api/phrases/executive_coercion/sample',
    fetchAnnoyingManager: '/api/phrases/annoying_manager/sample',
    fetchSassyMorning: '/api/phrases/sassy_morning/sample',
  };

  const friendlyCategoryNames = {
    no: 'Here is how to say no',
    yes: 'Here is how to say yes',
    executive_coercion: 'Here is how to sound like a high level executive',
    annoying_manager: 'Here is how to sound like a (micro) manager',
    sassy_morning: 'Start your day with sass',
  };

  const fetchPhrase = async (url) => {
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error fetching phrase:', error);
      return { phrase: 'Error fetching phrase.' };
    }
  };

  // Check if there is a category in the URL
  const urlParams = new URLSearchParams(window.location.search);
  const id = urlParams.get('id');

  if (id) {
    const url = `/api/phrases/${id}`;
    fetchPhrase(url).then(data => {
      document.getElementById('category').textContent = friendlyCategoryNames[data.category] || 'No category provided.';
      document.getElementById('output').textContent = data.phrase || 'No jargon received.';
      document.getElementById('output').hidden = false;
      document.getElementById('copyButton').hidden = false;
    }).catch(error => {
      document.getElementById('output').textContent = 'Error fetching jargon: ' + error.message;
    });
  }

  for (const button of document.getElementsByClassName('fetch')) {
    button.addEventListener('click', async (event) => {
      const outputDiv = document.getElementById('output');
      const categoryDiv = document.getElementById('category');
      const copyButton = document.getElementById('copyButton');
      categoryDiv.textContent = 'Loading...';
      outputDiv.textContent = 'Loading...';

      try {
        const data = await fetchPhrase(urls[event.target.id]);
        categoryDiv.hidden = false;
        outputDiv.hidden = false;
        copyButton.hidden = false;
        categoryDiv.textContent = friendlyCategoryNames[data.category] || 'No category provided.';
        outputDiv.textContent = data.phrase || 'No jargon received.';
        if (data.category !== undefined && data.id !== undefined) {
          window.history.pushState({}, '', `?id=${data.id}`);
        }
      } catch (error) {
        outputDiv.textContent = 'Error fetching jargon: ' + error.message;
      }
    });
  }

  document.getElementById('copyButton').addEventListener('click', () => {
    const prms = new URLSearchParams(window.location.search);
    const outputDiv = document.getElementById('output');
    navigator.clipboard.writeText(`> "${outputDiv.textContent}"\nfrom https://jaas.diegoc.io?id=${prms.get('id')}`);
  });