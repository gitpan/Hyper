var Hyper = {
   'Singleton':    {},
   '_singletonOf': {},
   '_global':      {},
   'DnD':          {},
   'Widget':       {},
   'Validator':    {},
};

Hyper.Validator.Single = Class.create();
Hyper.Validator.Single.prototype = {
    initialize: function (argRef) {
//      this.validationGroups = $A(argRef.validationGroups);
        this.validatorField   = $(argRef.validatorField);
        this.element          = argRef.element;

        Event.observe(argRef.element, 'change', this.validate.bindAsEventListener(this), true);
        if ( ! argRef.element._Hyper ) argRef.element._Hyper = {};
        argRef.element._Hyper['Hyper.Validator.Single'] = this;
    },
    validate: function (e) {
        var __this  = this ? this : Event.element(e);

        new Ajax.Request(
            '../validator.pl', {
                method:    'get',
                parameters: {
                    value: Form.Element.getValue(__this.element),
                    objid: __this.element.name,
                    uuid:  document.getElementsByName('uuid')[0].value
                },
                onSuccess: function(transport) {
                    var json = transport.responseText.evalJSON();

                    __this.validatorField.update(json.message);
/*                    if (__this.validationGroups) {
                        var isValid = json.isValid == 0 ? false : true;
                        __this.validationGroups.each(function(group) {
                            $(group).setValidStateOf({
                                id:      __this.id,
                                isValid: isValid
                            });
                        });
                    }*/
                }
            }
        );
    }
};


Hyper.Singleton.keyCapture = Class.create();
Hyper.Singleton.keyCapture.prototype = {
   initialize: function () {
       Hyper._global.keyCapture = {};

       // keydown
       Event.observe(document, 'keydown', function (event) {
           Hyper._global.keyCapture[
               Hyper.Singleton.keyCapture.prototype.keyCodeToString(event.charCode || event.keyCode)
           ] = true;
       });
       // keyup
       Event.observe(document, 'keyup', function (event) {
           Hyper._global.keyCapture[
               Hyper.Singleton.keyCapture.prototype.keyCodeToString(event.charCode || event.keyCode)
           ] = false;
       });
   },
   keyCodeToString: function(keyCode) {
       var keyNameOf = {
           16: 'shift',
           17: 'ctrl'
       };

       return keyNameOf[keyCode];
   },
   isDown: function(keyName) {
       return Hyper._global.keyCapture[keyName];
   }
};
Hyper.Singleton.Identifier = Class.create();
Hyper.Singleton.Identifier.prototype = {
    initialize: function () {
        this.conter = 1;
    },
    createId: function() {
        return 'cji_' + this.conter++;
    }
};
// initialize all singletons
Object.keys(Hyper.Singleton).each(
    function (className) {
        Hyper.Singleton[className].singleton = function () {
            if (!Hyper._singletonOf[className]) {
                Hyper._singletonOf[className] = new Hyper.Singleton[className];
            }
            return Hyper._singletonOf[className];
        };
    }
);

//END Common Hyper Crap

Hyper.DnD._current            = { elements: [], height: 0 };
Hyper.DnD.Container           = Class.create();
Hyper.DnD.Container.prototype = {
    initialize: function(element, options) {
        this.id             = Hyper.Singleton.Identifier.singleton().createId();
        this.transitions    = [];     // to other container
        this.draggables     = $H({}); // current sub elements id: element
        this.isSelectedOf   = $H({});
        this.lastSelectedId = null;
        this.mouseIsDown    = false;
        this.isDragging     = false;
        this.options        = $H(options);
        this.toBeSelected   = null;

        this._initDragContainer();

        // extend our object and html element
        this.element = element;
        if (!element._Hyper) element._Hyper = {};
        element._Hyper['DnD.Container'] = this;
           
        // initialize draggables
        var __this = this;
        element.immediateDescendants().each(
            function(descendant) {
                if (    ! __this.options.draggable
                     || ! __this.options.draggable.fixedClass
                     || ! __this.options.draggable.fixedClass == descendant.className ) {
                    new Hyper.DnD.Draggable(descendant, element);
                }
            }
        );

        // call serialize callbacks
        if ( this.options.serializeCallback )
            this.options.serializeCallback(this);

        // mousedown can be on every place of our document
        //Event.observe(document, 'mousedown', this.eventMouseDown.bindAsEventListener(this));
        // mousemove/element dragging is possible over whole document
        Event.observe(document, 'mousemove', this.moveDraggables.bindAsEventListener(this));
        // mouseup can be on every place of our document
        Event.observe(document, 'mouseup',   this.eventMouseUp.bindAsEventListener(this));
    },
    _initDragContainer: function () {
        if ( ! this.dragContainer ) {
            this.dragContainer           = document.createElement('div');
            this.dragContainer.className = this.options.dragContainerClass;
            Element.setStyle(this.dragContainer, {'zIndex': 200, 'position': 'absolute'});
            document.body.appendChild(this.dragContainer);
        }
        this.dragContainer.innerHTML = '';
        Element.hide(this.dragContainer);
    },
    eventMouseUp: function(event) {
        this.mouseIsDown = false;
       
        if ( this.isDragging && this.isSelectedOf.any() ) {
            var __this = this;
            var pointer = [Event.pointerX(event), Event.pointerY(event)];
            var overContainer = this.transitions.find(
                function (container) {
                    return Position.within(container.element, pointer[0], pointer[1]);
                }
            );
            var selectedIds = this.isSelectedOf.keys();
            if (overContainer) {
                var dropAfter = overContainer.draggables.values().find(
                    function (draggable) {
                        return Position.within(draggable.element, pointer[0], pointer[1]);
                    }
                );
                this.moveSelectedDraggables(overContainer, dropAfter);
            }
            else {
                selectedIds.each(
                    function(id) {
                        var draggable = __this.draggables[id];
                        draggable.element.setStyle({'visibility': ''});
                    }
                );
            }
            this._initDragContainer(); // clean dragContainer
            this.isDragging = false;

            // restore document cursor
            document.body.style.cursor = this._defaultCursor;
        }
        else if ( this.toBeSelected ) {
            this._handleDraggableSelection();
        }

        Event.stop(event);
    },
    _handleDraggableSelection: function () {
        var keyCapture = Hyper.Singleton.keyCapture.singleton();
        if ( keyCapture.isDown('shift') ) {
            var from = this.getLastSelected();
            if (from) {
                this.selectFromTo(from, this.toBeSelected);
            }
            else {
                this.selectDraggable(this.toBeSelected);
            }
        }
        else if ( keyCapture.isDown('ctrl') ) {
            this.toggleDraggable(this.toBeSelected);
        }
        else {
            this.deselectAllDraggables().selectDraggable(this.toBeSelected);
        }
        // fix text selection in IE
        if (document.selection) document.selection.empty();
        
        this.toBeSelected = null;
    },
    moveSelectedDraggables: function (toContainer, dropAfter) {
        var __this = this;
        this.isSelectedOf.keys().each(
            function(id) {
                var draggable = __this.removeDraggable(__this.draggables[id]);
                if ( dropAfter && dropAfter.element.nextSibling ) {
                    toContainer.element.insertBefore(draggable.element, dropAfter.element.nextSibling);
                }
                else {
                    toContainer.element.appendChild(draggable.element);
                }
                draggable.resetLayout();
                toContainer.addDraggable(draggable);
            }
        );
        // call serialize callbacks
        if ( this.options.serializeCallback )
            this.options.serializeCallback(this);
        if ( toContainer.options.serializeCallback )
            toContainer.options.serializeCallback(toContainer);
    },
    moveDraggables: function(event) {
        if ( this.mouseIsDown ) {
            var pointer = [Event.pointerX(event), Event.pointerY(event)];
            if ( this._lastPointer ) {
                // Mozilla-based browsers fire successive mousemove events with
                // the same coordinates, prevent needless redrawing (moz bug?)
                if ( this._lastPointer.inspect() == pointer.inspect() ) return;

                /* only neccessary if usability review likes this
                // fix IE - if position of pointer hasn't moved at least 8 pixels => return
                if ( ! this.isDragging ) {
                    var sqrtOf = Math.pow(pointer[0] - this._lastPointer[0], 2) + Math.pow(pointer[1] - this._lastPointer[1], 2);
                    window.status = sqrtOf;
                    if ( ! sqrtOf || Math.sqrt(sqrtOf) < 8 ) return;
                    this._lastPointer = pointer;
                    this.isDragging   = true;
                }*/
            }
            else {
                this._lastPointer = pointer;
                return;
            }
            
            var keyCapture = Hyper.Singleton.keyCapture.singleton();
            if ( this.toBeSelected && ( keyCapture.isDown('ctrl') || keyCapture.isDown('shift') ) ) {
                this._handleDraggableSelection(); // additional selection
            }
            else if ( this.toBeSelected && ! this.isSelectedOf[this.toBeSelected.id] )  {
                // clicked element is not selected => deselect all 
                this.deselectAllDraggables().selectDraggable(this.toBeSelected);
            }
            if ( this.isSelectedOf.any() ) {
                if ( ! this.dragContainer.hasChildNodes() ) {
                    var __this = this;
                    this.isSelectedOf.keys().each(
                        function (id) {
                            var element       = __this.draggables[id].element;
                            var clonedElement = element.cloneNode(element);
                            __this.dragContainer.appendChild(clonedElement);
                            if (__this.options.draggable && __this.options.draggable.draggingClass) {
                                clonedElement.className = __this.options.draggable.draggingClass;
                            }
                            element.setStyle({'visibility': 'hidden'});
                        }
                    );
                    this.dragContainer.show();
                    // save cursor for restore and set cursor to pointer
                    this._defaultCursor        = document.body.style.cursor;
                    document.body.style.cursor = 'pointer';
                }
                this.dragContainer.setStyle({'left': pointer[0] + 'px', 'top': pointer[1] + 'px'});
                this.isDragging = true;
                // fix text selection in IE
                if (document.selection) document.selection.empty();
            }
            else {
                this.isDragging = false;
            }
        }
        Event.stop(event);
    },
    addDraggable: function(draggable) {
        this.draggables[draggable.id] = draggable;
        draggable.container           = this;
    },
    removeDraggable: function(draggable) {
        if (this.lastSelectedId == draggable.id)
            this.lastSelectedId = null;
        this.deselectDraggable(draggable);
        this.draggables.remove(draggable.id);
        this.element.removeChild(draggable.element);
        return draggable;
    },
    toggleDraggable: function(draggable) {
        return this.isSelectedOf[draggable.id]
            ? this.deselectDraggable(draggable)
            : this.selectDraggable(draggable);
    },
    selectDraggable: function(draggable) {
        if ( this.draggables[draggable.id] ) {
            this.lastSelectedId             = draggable.id;
            this.isSelectedOf[draggable.id] = true;
            if (this.options.draggable && this.options.draggable.selectedClass) {
                draggable.element.className = this.options.draggable.selectedClass;
            }
        }
        return this;
    },
    selectAllDraggables: function() {
        var __this = this;
        this.draggables.values().each(function (d) { __this.selectDraggable(d); });
        return this;
    },
    deselectAllDraggables: function() {
        var __this = this;
        this.draggables.values().each(function (d) { __this.deselectDraggable(d); });
        return this;
    },
    deselectDraggable: function(draggable) {
        this.isSelectedOf.remove(draggable.id);
        draggable.resetLayout();
        return this;
    },
    getLastSelected: function() {
        return this.lastSelectedId != null
            ? this.draggables[this.lastSelectedId]
            : null;
    },
    selectFromTo: function(from, to) {
        var __this       = this;
        var firstElement = this.element.immediateDescendants().find(function(d) {
            if ( d._Hyper && d._Hyper['DnD.Draggable'] ) {
                var currentId = d._Hyper['DnD.Draggable'].id;
                return currentId == from.id || currentId == to.id;
            }
        });
        var toId = firstElement._Hyper['DnD.Draggable'].id == from.id ? to.id : from.id;
        this.selectDraggable(firstElement._Hyper['DnD.Draggable']);
        firstElement.nextSiblings().find(function (e) {
            var dnd = e._Hyper['DnD.Draggable'];
            if (dnd.id == toId) {
                __this.selectDraggable(dnd);
                return true;
            }
            else {
                __this.toggleDraggable(dnd);
            }
        });
        this.lasSelectedId = to.id;
    }
};
Hyper.DnD.Draggable           = Class.create();
Hyper.DnD.Draggable.prototype = {
    initialize: function (element) {
        this.id             = Hyper.Singleton.Identifier.singleton().createId();
        this.zIndex         = element.getStyle('z-index') ? element.getStyle('z-index') : 1;
        this.element        = element;
        this._originalClass = element.className;
        if (!element._Hyper) element._Hyper = {};
        element._Hyper['DnD.Draggable'] = this;
        // register in container
        element.parentNode._Hyper['DnD.Container'].addDraggable(this);

        // listen to mousedown
        Event.observe(this.element, 'mousedown', this.eventMouseDown.bindAsEventListener(this));
    },
    eventMouseDown: function (event) {
        if ( Event.isLeftClick(event) ) {
            // abort on form elements, fixes a Firefox issue
            var src = Event.element(event);
            if((tag_name = src.tagName.toUpperCase()) && (
                tag_name=='INPUT' ||
                tag_name=='SELECT' ||
                tag_name=='OPTION' ||
                tag_name=='BUTTON' ||
                tag_name=='TEXTAREA')) return;
            this.container.toBeSelected = this;
            this.container.mouseIsDown  = true;
            Event.stop(event);
        }
    },
    resetLayout: function () {
        this.element.setStyle({'visibility': ''});
        this.element.className = this._originalClass;
    }
};
