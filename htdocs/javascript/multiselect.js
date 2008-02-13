

/**
 * Javascriupt multi-selection
 * @version 0.3.5b
 * @license MIT Style
 * @alias  MultiSelect
 * @param  {element}
 * @usage = new MultiSelect(element);
 * 
 * @author firejune <to@firejune.com>
 * @url http://firejune.com/
 * 
 * @requires 
 *   - prototype <http://www.prototypejs.org>
 *   - scriptaculous <http://script.aculo.us>
 * 
 */

var MultiSelect = Class.create();
MultiSelect.prototype = {
  initialize: function(element, options){
    this.options = Object.extend({
      dragSelect   : true,
      rectangleCN  : 'MS-rectangle',
      selectCN     : 'MS-select',
      unselectCN   : 'MS-unselect',
      borderWidth  : 2,
      onChange     : Prototype.emptyFunction
    }, options || {});
   
    this.items    = []; // item arrays
    this.area     = $(element); // drag event area
    this.overflow = !/visible/.test(Element.getStyle(this.area, 'overflow'));

    // set drag or toggle events
    if(this.options.dragSelect){
      this.rect = document.createElement('div');
      Element.setOpacity(this.rect, 0.6);
      Element.setStyle(this.rect, {
        position:'absolute', display:'none',
        border: this.options.borderWidth + 'px solid #fb5'
      });
      Element.addClassName(this.rect, this.options.rectangleCN);
      document.body.insertBefore(this.rect, document.body.firstChild);
      Element.makePositioned(this.rect); // fix IE

      this.active         = false;
      this.resizing       = false;

      this.eventMouseDown = this.eventStart.bindAsEventListener(this);
      this.eventMouseUp   = this.eventEnd.bindAsEventListener(this);
      //this.eventDblClick  = this.dblClickEvent.bindAsEventListener(this);
      this.eventMouseMove = this.eventDrag.bindAsEventListener(this);
    }else {
      this.eventClick     = this.eventToggle.bindAsEventListener(this);
    }

    //  onScroll items update utility
    this.onScroll = function(){
      clearTimeout(this.moveTimeout);
      this.moveTimeout = setTimeout(function(){ 
        this.setOffset(true);
      }.bind(this), 200);
    }.bind(this);

    //  onResize items update utility
    this.eventResize = function(){
      this.setOffset(true);
    }.bindAsEventListener(this);
    //this.eventKeypress    = this.key.bindAsEventListener(this);

    //set items offset
    this.setOffset();
    //register mouse events
    this.eventRegister();

    Event.observe(window, 'unload', this.eventUnregister.bindAsEventListener(this));
  },
  eventRegister: function(){
    if(this.options.dragSelect){
      Event.observe(this.rect.parentNode, "mousedown", this.eventMouseDown);
      Event.observe(document, "mouseup", this.eventMouseUp);
      //Event.observe(document, "dblclick", this.eventDblClick);
      Event.observe(document, "mousemove", this.eventMouseMove);
    } else {
      Event.observe(document, "click", this.eventClick);
    }
    Event.observe(window, "resize", this.eventResize);
    Event.observe(this.area, 'scroll', this.onScroll);
    //Event.observe(document, "keypress", this.eventKeypress);
  },
  eventUnregister: function(){
    if(this.options.dragSelect){
      Event.stopObserving(this.rect.parentNode, "mousedown", this.eventMouseDown);
      Event.stopObserving(document, "mouseup", this.eventMouseUp);
      //Event.stopObserving(document, "dblclick", this.eventDblClick);
      Event.stopObserving(document, "mousemove", this.eventMouseMove);
    } else {
      Event.stopObserving(document, "click", this.eventClick);
    }
    Event.stopObserving(window, "resize", this.eventResize);
    Event.stopObserving(this.area, 'scroll', this.onScroll);
    //Event.stopObserving(document, "keypress", this.eventKeypress);

    this.rect = null; this.area = null; // Fix memoryleak for IE
  },
  getOffset: function(element){
    var offsets = Position.cumulativeOffset(element);
    var ot = offsets[1] + this.options.borderWidth;
    var ol = offsets[0] + this.options.borderWidth;
    var ow = parseInt(Element.getStyle(element, 'width'));
    var oh = parseInt(Element.getStyle(element, 'height'));
    if(!oh){
      oh = $(element).offsetHeight; // IE, NaN bug fix
    }
    return {width:ow, height:oh, left:ol, top:ot};
  },
  setOffset: function(reset){
    var nodes = this.area.down('ul').immediateDescendants();
    var su = false, st = false;
    if(nodes){
      this.items = []; // fix for MSIE
      for (var i = 0; i < nodes.length; i++){
        su = reset? Element.hasClassName(nodes[i], this.options.selectCN) ? true : false : su;
        st = reset? su : st;
        var offsets =  this.getOffset(nodes[i]);
        if(this.overflow){
          var pos = Position.realOffset(this.area);
          offsets.left = offsets.left - pos[0];
          offsets.top = offsets.top - pos[1];
        }
        if(!reset){
          Element.addClassName(nodes[i], this.options.unselectCN);
        }
        var arrayData = {
          element: nodes[i], success:su, status:st, width:offsets.width, 
          height:offsets.height, top:offsets.top, left:offsets.left
        };
        this.items.push(arrayData);
      }
    }
  },
  checkArea: function(event, offsets){
    var pointer = {x:Event.pointerX(event), y:Event.pointerY(event)};
    if(offsets.tagName){
      offsets =  this.getOffset(offsets);
    }
    //debug('Multiselector error :' + e.name, e.message);

    var PLX = offsets.left - pointer.x;
    var PTY = offsets.top - pointer.y;
    if((PLX < 0 && PLX > 0 - offsets.width) &&
      (PTY < 0 && PTY > 0 - offsets.height)){
      return true;
    } else {
      return false;
    }
  },
  checkPoint: function(event){
    var array = this.items, success;
    for (var i = 0; i < array.length; i++){
      if(this.checkArea(event, array[i])){
        success = (array[i].success)? false : true;
        array[i].success = success; array[i].status = success;
        this.reverseUnit(array[i].element, success);
      }
    }
    Event.stop(event);
  },
  isClear:function(event){
    var src = Event.element(event);
    // condition checkArea
    if(src.tagName && (
      src.tagName=='A' ||
      src.tagName=='INPUT' ||
      src.tagName=='SELECT' ||
      src.tagName=='BUTTON' ||
      src.tagName=='TEXTAREA') ||
      !this.checkArea(event, this.area)){
      debug('isClear');
      return true;
    }
  },
  eventStart: function(event){
    if(Event.isLeftClick(event)){
      var pointer = {x:Event.pointerX(event), y:Event.pointerY(event)};

      if(this.isClear(event)) {
        return; 
      }

      this.rect.style.left = pointer.x + 'px';
      this.rect.style.top = pointer.y + 1 +  'px';
      this.rect.style.display = 'block';
      this.active = true;
      this.startX = pointer.x;
      this.startY = pointer.y;

      Event.stop(event);
    }
  },
  eventDrag: function(event){
    if(this.active && this.options.dragSelect){
      if(!this.resizing){
        this.resizing = true;
      }
      this.drawRect(event);
      this.innerRect(event);

      if(navigator.appVersion.indexOf('AppleWebKit') > 0){
        window.scrollBy(0,0);
      } 
      Event.stop(event);
      return false;
    }
  },
  eventEnd: function(event){
    // Drag select or toggle
    if(this.active && this.resizing){
      this.finishDrag(event, true);
      Event.stop(event);
    } else {
      this.eventToggle(event);
    }

    this.active = false;
    this.resizing = false;
    this.rect.style.display = 'none';

    this.options.onChange();
  },
  finishDrag: function(event, success){
    this.active = false;
    this.resizing = false;
    if(this.options.resize){
      this.options.resize(this.rect);
    }
    this.rect.style.height = 0;
    this.rect.style.width = 0;
    for (var i = 0; i < this.items.length; i++){
      this.items[i].status = this.items[i].success;
    }
  },
  // draw select area rectangle 
  drawRect: function(event){
    var pointer = {x:Event.pointerX(event), y:Event.pointerY(event)};
    var style = this.rect.style, newHeightN, newWidthW, newHeightS, newWidthE;

    newHeightN = this.startY - pointer.y;
    if(newHeightN > 0){
      style.height = newHeightN + "px";
      style.top = (this.startY - newHeightN) + "px";
    }
    newWidthW = this.startX - pointer.x;
    if(newWidthW > 0){
      style.left = (this.startX - newWidthW)  + "px";
      style.width = newWidthW + "px";
    }
    newHeightS = pointer.y - this.startY - (this.options.borderWidth * 2);
    if(newHeightS > 0){
      style.height = newHeightS + "px";
    }
    newWidthE = pointer.x - this.startX - (this.options.borderWidth * 2);
    if(newWidthE > 0){
      style.width = newWidthE + "px";
    }
    if(style.visibility == "hidden"){
      style.visibility = ""; // fix for gecko rendering
    }
  },
  //check rectangle under items 
  innerRect: function(){
    var rectTLX = this.rect.offsetLeft;
    var rectTLY = this.rect.offsetTop;
    var rectBRX = rectTLX + this.rect.offsetWidth;
    var rectBRY = rectTLY + this.rect.offsetHeight;
    var array = this.items;

    for (var i = 0; i < array.length; i++){
      var width = array[i].left + array[i].width;
      var height = array[i].top + array[i].height;
      if((rectTLX - width < 0 || rectTLX - array[i].left < 0 - array[i].width) &&
        (rectTLY - height < 0 || rectTLY - array[i].top < 0 - array[i].height ) &&
        rectBRX - width > 0 - array[i].width && rectBRY - height > 0 - array[i].height){
        if(array[i].status){
          array[i].success = false;
        } else {
          array[i].success = true;
        }
      } else {
        if(array[i].status){
          array[i].success = true;
        } else {
          array[i].success = false;
        }
      }
      this.reverseUnit(array[i].element, array[i].success);
    }
  },
  // reverse selection item
  reverseUnit: function(element, success){
    var addClassName, removeClassName;
    if(success){
      addClassName = this.options.unselectCN;
      removeClassName = this.options.selectCN;   
    } else {
      addClassName = this.options.selectCN;
      removeClassName = this.options.unselectCN;                                            
    }
    Element.removeClassName(element, addClassName);
    Element.addClassName(element, removeClassName); 
  },
  // Todo : dblClick event
  dblClickEvent: function(event){
    var src = Event.element(event);
    if(src.tagName=='IMG'){
      document.location = $(src).up().href;
    }
    Event.stop(event);
  },
  eventToggle: function(event){
    if(this.isClear(event)) {
      return; 
    }

    var flag = true;
    for (var i = 0; i < this.items.length; i++){
      if(this.checkArea(event, this.items[i].element)){
        flag = false;
        break;
      }
    }

    if(flag){
      this.selectAll(false);
    }

    this.checkPoint(event);
    this.options.onChange();
  },
  selectAll: function(success){
    for (var i = 0; i < this.items.length; i++){
      this.items[i].success = success;
      this.items[i].status = success;
      this.reverseUnit(this.items[i].element, success);
    }

    this.options.onChange();
    return false;
  },
  key: function(event){
    if(this.active){
      if(event.keyCode==Event.KEY_ESC){
        this.finishDrag(event, false);
        Event.stop(event);
      }
    }
  },
  remove: function(){
    this.eventUnregister();
    this.rect.remove();
  }
};