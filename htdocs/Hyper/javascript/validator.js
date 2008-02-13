var Hyper = $H({
    Version:          '0.1',
    prototypeVersion: parseFloat(Prototype.Version.split(".")[0] + "." + Prototype.Version.split(".")[1]),
    Validator:        $H({
        Group: 	Class.create(),
        Base:  	Class.create()       
    })
});

Hyper.Validator.Group.prototype = {
    initialize: function (argRef) {
        var baseElements = $H(argRef.baseElements);
        var elementStates = $H({});
        baseElements.keys().each(function (key) {
            var baseElement = $(key);
            new Ajax.Request(
                'validator.pl', {
                    method:    'get',
                    parameters: {
                        value: Form.Element.getValue(baseElement),
                        objid: $(baseElement).name,
                        cpvc:  $(baseElement).cacheFile
                    },
                    onSuccess: function(transport, json) {
                        elementStates[key] = json['isValid'] == 0 ? false : true;
                    }
                }
            );
        });
        this.baseElements  = baseElements;
        this.elementStates = elementStates;
        this.cacheFile     = argRef.cacheFile;

        Object.extend($(argRef.errorId), this);
    },
    setValidStateOf: function(argRef) {
        this.elementStates[argRef['id']] = argRef['isValid'];
        this.handleAction();
    },
    handleAction: function () {
        var __method  = this;
        var isInvalid = __method.elementStates.values().include(false);
        if (isInvalid) {
            Element.update(__method, '');
            return;
        }
        var ajaxValue = $H({});
        __method.baseElements.each(function (pair) {
            if (typeof pair.value !== 'function')
                ajaxValue[pair.value] = Form.Element.getValue(pair.key);
        });
        new Ajax.Request(
            'validator_group.pl', {
                parameters: {
                    value: ajaxValue.toJSONString(),
                    objid: __method.id,
                    cpgc:  __method.cacheFile
                    },
                method:     'get',
                onSuccess:  function(transport, json) {
                    __method.update(json['message']);
                }
            }
            );
   },
   addData: function(args) {
        this.requestData[args['used_as']] = Form.Element.getValue(args['id']);
   }
};

Hyper.Validator.Base.prototype = {
    initialize: function (argRef) {
        this.errorField       = $(argRef.errorId);
        this.cacheFile        = argRef.cacheFile;
        this.validationGroups = $A(argRef.validationGroups);
        Object.extend($(argRef.validatorField), this);
        Event.observe(argRef.element, 'change', this.validate, true);
    },
    validate: function(e) {
        var __method  = e ? Event.element(e) : this;

        new Ajax.Request(
            'validator.pl', {
                method:    'get',
                parameters: {
                    value: Form.Element.getValue(__method),
                    objid: __method.name,
                    cpvc:  __method.cacheFile
                },
                onSuccess: function(transport, json) {
                    __method.errorField.update(json['message']);
                    if (__method.validationGroups) {
                        var isValid = json['isValid'] == 0 ? false : true;
                        __method.validationGroups.each(function(group) {
                            $(group).setValidStateOf({
                                id:      __method.id,
                                isValid: isValid
                            });
                        });
                    }
                }
            }
        );
    }
};
