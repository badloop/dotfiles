// GitHub Actions Log -> Neovim Bookmarklet
// 
// Opens the raw GitHub Actions log directly in Neovim via nvim:// protocol handler.
//
// INSTALLATION:
// 1. Create a new bookmark in your browser
// 2. Set the name to something like "Open in Neovim"
// 3. Set the URL to the minified bookmarklet code below
//
// USAGE:
// 1. Navigate to a GitHub Actions job page
// 2. Click the bookmarklet
// 3. Neovim opens in a new terminal with the log

(function() {
  const url = window.location.href;
  
  // Pattern 1: /owner/repo/commit/{sha}/checks/{check_id}
  const checksMatch = url.match(/github\.com\/([^/]+)\/([^/]+)\/commit\/([a-f0-9]+)\/checks\/(\d+)/);
  
  // Pattern 2: /owner/repo/actions/runs/{run_id}/job/{job_id}
  const jobMatch = url.match(/github\.com\/([^/]+)\/([^/]+)\/actions\/runs\/(\d+)\/job\/(\d+)/);
  
  let logUrl;
  
  if (checksMatch) {
    const [, owner, repo, sha, checkId] = checksMatch;
    logUrl = `https://github.com/${owner}/${repo}/commit/${sha}/checks/${checkId}/logs`;
    
  } else if (jobMatch) {
    const [, owner, repo, runId, jobId] = jobMatch;
    
    // Try to find the checks log link in the page
    const logsLink = document.querySelector('a[href*="/checks/"][href$="/logs"]');
    if (logsLink) {
      logUrl = logsLink.href;
    } else {
      // Try to get commit SHA from the page
      const commitLink = document.querySelector('a[href*="/commit/"]');
      let sha = null;
      if (commitLink) {
        const commitMatch = commitLink.href.match(/\/commit\/([a-f0-9]+)/);
        if (commitMatch) sha = commitMatch[1];
      }
      
      if (sha) {
        logUrl = `https://github.com/${owner}/${repo}/commit/${sha}/checks/${jobId}/logs`;
      } else {
        alert('Could not find the raw log URL.\n\nTry navigating to the commit checks page.');
        return;
      }
    }
  } else {
    alert('Not on a GitHub Actions page.\n\nSupported URL patterns:\n- /owner/repo/actions/runs/123/job/456\n- /owner/repo/commit/sha/checks/123');
    return;
  }
  
  // Open via nvim:// protocol handler
  window.location.href = 'nvim://' + logUrl;
})();

// MINIFIED BOOKMARKLET (copy this as the bookmark URL):
// javascript:(function(){const e=window.location.href,o=e.match(/github\.com\/([^/]+)\/([^/]+)\/commit\/([a-f0-9]+)\/checks\/(\d+)/),t=e.match(/github\.com\/([^/]+)\/([^/]+)\/actions\/runs\/(\d+)\/job\/(\d+)/);let n;if(o){const[,e,t,r,c]=o;n=`https://github.com/${e}/${t}/commit/${r}/checks/${c}/logs`}else{if(!t)return void alert("Not on a GitHub Actions page.\n\nSupported URL patterns:\n- /owner/repo/actions/runs/123/job/456\n- /owner/repo/commit/sha/checks/123");{const[,e,o,r,c]=t,s=document.querySelector('a[href*="/checks/"][href$="/logs"]');if(s)n=s.href;else{const t=document.querySelector('a[href*="/commit/"]');let r=null;if(t){const e=t.href.match(/\/commit\/([a-f0-9]+)/);e&&(r=e[1])}if(!r)return void alert("Could not find the raw log URL.\n\nTry navigating to the commit checks page.");n=`https://github.com/${e}/${o}/commit/${r}/checks/${c}/logs`}}}window.location.href="nvim://"+n})();
