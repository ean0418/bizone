function boardCheck() {
    var b_text = document.boardForm.b_text;

    if (isEmpty(bn_text)) {
        alert("텍스트 작성 부탁드려요");
        b_text.value = "";
        return false;
    }
    return true;
}

function searchCheck() {
    var s_text = document.boardSearchForm.search;

    if (isEmpty(_text)) {
        alert("2글자이상 입력부탁드려요");
        s_text.value = "";
        s_text.focus();
        return false;
    }
    return true;
}