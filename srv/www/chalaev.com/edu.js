Packages.load("2.js").then(()=>{hideClassD("r");hideClassD("rt")});

var RBs=document.querySelectorAll("input[type=radio]");

RBs[0].checked = true;


forEach1(RBs,x=>x.addEventListener('input',e=>{
    if(e.target.value=="Eng") {hideClassD("r");hideClassD("rt");showClassD("re","list-item")}
    else {showClassD("rt");showClassD("r","list-item");hideClassD("re")}}));
				   
	
// var tmp=document.querySelectorAll("li.re")[0];
// tmp.style.display
