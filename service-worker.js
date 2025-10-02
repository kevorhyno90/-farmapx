self.addEventListener('install', event => {
  const CACHE_NAME = 'farmark-cache-v3'; // Changed cache name
  const urlsToCache = [
    '/',
    '/index.html',
    '/style.css', // Corrected path
    '/script.js',
    '/firebase-config.js',
    '/manifest.json',
    '/images/icon-192.png',
    '/images/icon-512.png'
  ];
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('Opened cache');
        return cache.addAll(urlsToCache);
      })
  );
});

self.addEventListener('activate', event => {
  var cacheKeeplist = ['farmark-cache-v3']; // Use the new cache name

  event.waitUntil(
    caches.keys().then(keyList => {
      return Promise.all(keyList.map(key => {
        if (cacheKeeplist.indexOf(key) === -1) {
          return caches.delete(key);
        }
      }));
    })
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
