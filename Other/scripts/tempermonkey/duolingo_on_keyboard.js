kafm_keyMap = {}
Array.from({length: 10}, (a, i) => i).forEach(
    function (n) {
        kafm_keyMap[48 + n] = String(n);
        kafm_keyMap[96 + n] = String(n);
    }
);


let selectors = {};
selectors['select'] = '#root > div:nth-child(2) > div > div > div > div:nth-child(2) > div > div > div > div > div:nth-child(2) > div:nth-child(2)'
selectors['translate'] = '#root > div:nth-child(1) > div > div > div > div:nth-child(2) > div > div > div > div > div:nth-child(2) > div:nth-child(2) > div > div > div:nth-child(2) > div';

let type = undefined;
let select = undefined;

for (let selector in selectors) {
    let element = document.querySelector(selectors[selector]);
    if (element) {
        type = selector;
        select = element;
        break;
    }
}

switch (type) {
    case 'select':
        select.click();
        break;
    case 'translate':
        select.click();
        break;
}

// data-test="word-bank"
document.querySelector('div[data-test="word-bank"]')
document.querySelectorAll("div[data-test]")[2].firstElementChild.firstElementChild.innerHTML = '<span class="Z7UoT _2S0Zh _2f9B3">2</span>' + document.querySelectorAll("div[data-test]")[2].firstElementChild.firstElementChild.innerHTML