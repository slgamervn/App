const CACHE_VERSION = "hanh-tinh-xanh-v1";
const SHELL = ["./planet_garden.html","./manifest.webmanifest","./icon-192.png","./icon-512.png"];
self.addEventListener("install",event=>{event.waitUntil(caches.open(CACHE_VERSION).then(c=>c.addAll(SHELL)).then(()=>self.skipWaiting()));});
self.addEventListener("activate",event=>{event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE_VERSION).map(k=>caches.delete(k)))).then(()=>self.clients.claim()));});
self.addEventListener("fetch",event=>{
 const req=event.request; const url=new URL(req.url);
 if(req.method!=="GET"||url.origin!==self.location.origin)return;
 if(/supabase|firebase|database|\/rest\/v1\//i.test(url.href))return;
 if(!SHELL.some(p=>new URL(p,self.location.href).pathname===url.pathname))return;
 event.respondWith(caches.open(CACHE_VERSION).then(async cache=>{
   const cached=await cache.match(req);
   const update=fetch(req).then(res=>{if(res&&res.ok)cache.put(req,res.clone());return res;}).catch(()=>cached);
   return cached||update;
 }));
});
