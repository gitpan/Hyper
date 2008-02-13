Hyper.Widget.MultiSelect = Class.create();
Hyper.Widget.MultiSelect.prototype = {
    initialize: function(container, options) {
        var __this     = this;
        this.container = $A(container).map(function (c) { return $(c); });
        options        = $H(options);

        // set default serializeCallback
        if ( ! options.serializeCallback ) {
            options.serializeCallback = function(c) {
                var __form = c.element.up('form');
                $A(document.getElementsByName(c.element.id)).each(function (h) {
                    if (h && h.tagName.toLowerCase() == 'input') Element.remove(h);
                });
                c.element.immediateDescendants().each(
                    function (descendant) {
                        var realValue = descendant.getAttribute('value');
                        if ( typeof realValue == 'string' ) {
                            var hiddenField   = document.createElement('input');
                            hiddenField.type  = 'hidden';
                            hiddenField.name  = c.element.id;
                            hiddenField.value = realValue;
                            __form.appendChild(hiddenField);
                        }
                    }
                );
            };
        }
        // set default css classes
        if ( ! options.draggable ) {
            options.draggable = {
                'fixedClass':    'fixed',
                'selectedClass': 'selected',
                'draggingClass': 'dragging'
            };
        }
        if ( ! options.dragContainerClass )
            options.dragContainerClass = 'Hyper_Widget_MultiSelect_DragContainer';
        
        var containerObjects = this.container.map(function (c) {
            if ( ! c._Hyper ) c._Hyper = {};
            c._Hyper['Widget.MultiSelect'] = __this;
            return new Hyper.DnD.Container(c, options);
        });
        containerObjects.each(function(c) { c.transitions = containerObjects; });

        this.containerObjects = containerObjects;
    },
    allRight: function () {
        this.containerObjects[0].selectAllDraggables().moveSelectedDraggables(this.containerObjects[1]);
    },
    allLeft: function () {
        this.containerObjects[1].selectAllDraggables().moveSelectedDraggables(this.containerObjects[0]);
    },
    left: function () {
        this.containerObjects[1].moveSelectedDraggables(this.containerObjects[0]);
    },
    right: function () {
        this.containerObjects[0].moveSelectedDraggables(this.containerObjects[1]);
    }
};
