@import <Foundation/Foundation.j>

objj_class.prototype._ =
objj_object.prototype._ =
function(arg0)
{
    var args = [],
        selector;
        
    if (arg0 && typeof arg0 === "object")
    {
        var components = [];
        for (var c in arg0)
        {
            components.push(c);
            args.push(arg0[c]);
        }
        selector = components.join(":") + ":";
    }
    else if (typeof arg0 === "string")
        selector = arg0;
    else
        throw new Error("Must provide selector or hash");
    
    if (arguments.length > 1)
        Array.prototype.push.apply(args, Array.prototype.slice.call(arguments, 1));
    
    args.unshift(this, sel_getUid(selector));
    
    return objj_msgSend.apply(null, args);
}

function aliasSelector(aBase, aSelector, aName, aDescription)
{
    if (aBase.hasOwnProperty(aName))
        throw new Error("Conflict aliasing method '"+aName+"' to selector '"+aSelector+"' "+(aDescription||""));
    
    aBase[aName] = function() {
        return objj_msgSend.apply(null, [this, aSelector].concat(Array.prototype.slice.call(arguments)));
    }
    //aBase[aName] = new Function("return objj_msgSend.apply(null, [this, '"+aSelector+"'].concat(Array.prototype.slice.call(arguments)));");
}

function aliasSelectorI(aClass, aSelector, aName)
{
    aliasSelector(aClass.allocator.prototype, aSelector, aName, "on '"+aClass.name+"' instances");
}

function aliasSelectorC(aClass, aSelector, aName)
{
    aliasSelector(aClass, aSelector, aName, "on '"+aClass.name+"' class");
}

aliasSelectorC(CPObject, "alloc", "alloc");
aliasSelectorI(CPObject, "init", "init");

var a = [[CPObject alloc] init];
print(a);

var a = CPObject._("alloc")._("init");
print(a);

var a = CPObject.alloc().init();
print(a);

//aliasSelectorI(CPArray, "init", "init");
aliasSelectorC(CPArray, "arrayWithArray:", "arrayWithArray");

/*
asdf = function() {
    call_super(arguments);
    objj_msgSendSuper{super_class:arguments.callee.base, object:self}, _cmd, arguments);
}
asdf.base = "CPObject";
asdf();
*/

var a = [CPArray arrayWithArray:["A", "B", "C"]];
print(a);

var a = CPArray._("arrayWithArray:", ["A", "B", "C"]);
print(a);

var a = CPArray._({ arrayWithArray:["A", "B", "C"] });
print(a);

var a = CPArray.arrayWithArray(["A", "B", "C"]);
print(a);
