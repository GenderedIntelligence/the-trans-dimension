// custom-backend-task.js
import fs from "node:fs";
import fetch from "make-fetch-happen";

async function fetchAndCachePlaceCalData(config, context) {
  let placeCalData = null;
  const cacheDir = `${context.cwd}/.cache/`;
  const cachePath = `${context.cwd}/.cache/${config.collection}.json`;
  
  if (!fs.existsSync(cacheDir)) {
    fs.mkdirSync(cacheDir, (error, data) => {
      console.log("DATAEO", data);
      console.log("ERREO", error);
      return;
    });
  }
  
  if (fs.existsSync(cachePath)) {
    placeCalData = JSON.parse(fs.readFileSync(cachePath, 'utf8'));
  } else {
    const response = await fetch(config.url, {
      "method": "POST",
      "headers": { "content-type": "application/json" },
      "body": JSON.stringify({ "query": config.query.query })
    });
    if (response) {
      const collectionJson = response.json();
      fs.writeFileSync(cachePath, JSON.stringify(collectionJson));
      placeCalData = collectionJson;
    }
  }
  return placeCalData;
}

export {
  fetchAndCachePlaceCalData
};
