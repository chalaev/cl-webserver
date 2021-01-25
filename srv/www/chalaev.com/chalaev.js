Packages.load('menu.html').then(()=>{
    forEach1(document.querySelectorAll("ul.nav>li>a[href='"+thePage+"']"),x=>x.classList.add("current"))});

var header, body,MS=IDget("menu").style;
function menuHeight(){if(window.innerWidth>635) return 10; else return 20}

MS.height=menuHeight()+'px';

var EVF=function(){
    window.removeEventListener("scroll",EVF);
	var scrollY=Number(window.scrollY);
	if(scrollY<=50)MS.height=menuHeight()+'px';
    else MS.height="";
    setTimeout(()=>window.addEventListener("scroll",EVF),200)
};

whenReady(["verhAni"],function(){
    header=document.getElementsByClassName("header")[0];
    body=document.getElementById("verhAni");
    window.addEventListener("scroll",EVF);
    window.scrollTo(0,0)}) // перематываем окно наверх
