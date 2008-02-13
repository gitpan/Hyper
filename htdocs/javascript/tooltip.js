var agt=navigator.userAgent.toLowerCase();
var is_opera = (agt.indexOf("opera") != -1);
var is_nav  = ((agt.indexOf('mozilla')!=-1) && (agt.indexOf('spoofer')==-1)
            && (agt.indexOf('compatible') == -1) && (agt.indexOf('opera')==-1)
            && (agt.indexOf('webtv')==-1));
var is_ie = (agt.indexOf("msie") != -1);            
var is_mac = (agt.indexOf('mac') != -1);
var is_ie_mac = ((agt.indexOf('mac') != -1) && (agt.indexOf('msie') != -1));

var toolTipPosX = 0;
var toolTipPosY = 0;

Event.observe(window, 'load', function(event){Event.observe(document, 'mousemove', function(event){toolTipPosX = Event.pointerX(event);toolTipPosY = Event.pointerY(event);})});

function writetxt(msg){
setTooltipPosition();
if (((is_opera == false) && (is_nav == false) && (is_ie_mac == false)) 
|| ( (is_ie != false) && (is_opera == false) && (is_ie_mac == false))){
oPopup = window.createPopup();	
popupTooltip(msg);
} else {
var tooltip = $('navtxt');
if (msg != 0){
    tooltip.update(msg);
    tooltip.setStyle({display:'block'});
    setTooltipPosition();
} else {tooltip.hide();}
}
}

function getWindowSize(){
var windowWidth  = window.innerWidth != null
? window.innerWidth 
: document.documentElement && document.documentElement.clientWidth 
   ? document.documentElement.clientWidth 
   : document.body != null 
      ? document.body.clientWidth : null;

var windowHeight = window.innerHeight != null
? window.innerHeight 
: document.documentElement && document.documentElement.clientHeight 
   ? document.documentElement.clientHeight 
   : document.body != null
      ? document.body.clientHeight : null;
return [windowWidth, windowHeight];
}

function setTooltipPosition(){
var tooltip = $('navtxt');
if ( (typeof(document.getElementById('navtxt')) == 'undefined') || $('navtxt') == null){return true;}
else{

if ($('navtxt').style.display == 'none'){return true;}
tooltip.setStyle({top: toolTipPosY + 15 + 'px', left:toolTipPosX + 20 + 'px'});
var tooltipDimension = Element.getDimensions(tooltip);
var tooltipPosition = Position.cumulativeOffset(tooltip);
var windowSize = getWindowSize();

if (windowSize[0] < (tooltipPosition[0] + tooltipDimension.width)) {
    var checkLeft = windowSize[0] - toolTipPosX - tooltipDimension.width;
    if (checkLeft < 0){checkLeft = 0;}
    tooltip.setStyle({left:checkLeft+'px'}); 
} 
if (windowSize[1] < (tooltipPosition[1] + tooltipDimension.height)){
    var checkTop = tooltipPosition[1] - tooltipDimension.height;
    if (checkTop < 0){checkTip = 0;}
    tooltip.setStyle({top:checkTop +'px'});   
}
}
}

function popupTooltip(text, posX, posY){
var realHeight;
var realWidth;
// create new popupbody
if (text != 0){
	var oPopBody = oPopup.document.body;
	oPopBody.innerHTML = '<div id="ienavtxt" style="width:auto;height:auto;">'+text+'</div>';
	oPopBody.style.backgroundColor = $('navtxt').getStyle('background-color');
	oPopBody.style.borderColor = $('navtxt').getStyle('border-color');
	oPopBody.style.borderStyle = $('navtxt').getStyle('border-style');
	oPopBody.style.borderWidth = $('navtxt').getStyle('border-width');
	oPopBody.style.fontFamily = $('navtxt').getStyle('font-family');
	oPopBody.style.fontSize = $('navtxt').getStyle('font-size');
	oPopBody.style.padding = $('navtxt').getStyle('padding');
	oPopBody.style.color = $('navtxt').getStyle('color');
	oPopBody.style.height = 'auto';
	oPopBody.style.width = 'auto';

	if (typeof(acttext) != 'undefined'){
	if (text != acttext){
	oPopup.hide();
	oPopup.show(0, 0, 300, 0);
	realHeight = oPopBody.scrollHeight;
	realWidth = oPopBody.scrollWidth;
	oPopup.hide();
	}
	}
	acttext = text;
	if (oPopup.isOpen == false){
	oPopup.show(0, 0, 300, 0);
	realHeight = oPopBody.scrollHeight;
	realWidth = oPopBody.scrollWidth;
	oPopup.hide();
	var toTop = (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);
	var toLeft = (document.documentElement.scrollLeft ?	document.documentElement.scrollLeft : document.body.scrollLeft);
	if (event.srcElement.tagName != 'IMG'){ // we have a default tooltip created by perl
        if (posX && posY){
		oPopup.show(posX-10, posY-16, realWidth ,realHeight, document.body);
        }else{ 
	    oPopup.show(Event.pointerX(event) + toLeft, Event.pointerY(event) + toTop, realWidth ,realHeight, document.body);
        }        
	}else{	
	oPopup.show(20, 20, realWidth ,realHeight, event.srcElement);
	}
	}
}else{if(oPopup.isOpen == true){oPopup.hide();}}
}

function helpTip(msgElem,msgText){
var msgElement = msgElem;
if (msgElem != 0){
var elementPos = Position.cumulativeOffset($(msgElem));
elemDims = $(msgElem).getDimensions();
posX = elementPos[0];
posY = elementPos[1]; //+ elemDims.height;
}
if (((is_opera == false) && (is_nav == false) && (is_ie_mac == false)) 
	|| ( (is_ie != false) && (is_opera == false) && (is_ie_mac == false) )){
	if (msgElem != "0"){			
    posX = posX + 10;
	var mytext = msgText;
    oPopup = window.createPopup();	
    popupTooltip(mytext,posX,posY);
	} else { popupTooltip(0); }
} else {
	if ((msgText != '') && (msgElem != '0')){
    if ($(msgElem).tagName.toLowerCase() == 'textarea'){
	posY = posY - 20;
    } else {
    posY = posY - elemDims.height;
    }
	$('helptip').setStyle({top: posY+'px',left:posX+'px',visibility:'visible',display:'block',height:'15px',padding:0,margin:0,width:'auto'});
    $('helptip').update('&nbsp;'+msgText);
    $('helptip').className='navtext';            
	}else{ //Effect.BlindUp($('helptip'), {duration:0.2}); 
	  $('helptip').hide();
    }
}
}
