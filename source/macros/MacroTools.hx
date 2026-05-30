package macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Type.ClassType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.Access;

class MacroTools {
  // call as: @:build(Macros.makeStatics(macro new Source()))
  public static function makeStatics(instanceExpr:Expr):Array<Field> {
    // get compile-time type of instanceExpr
    var t:Type = Context.typeExpr(instanceExpr);

    // ensure it's a class instance type
    var cl:ClassType = switch (t) {
      case Type.TInst(c, _): c;
      default:
        Context.error("expected a class instance expression", instanceExpr.pos);
        return [];
    }

    var cdef = cl.get();
    var out = new Array<Field>();

    // private static instance field (evaluated once)
    var instField:Field = {
      name: "__macro_instance",
      doc: null,
      meta: [],
      access: Access.APrivate,
      kind: Field.FVar,
      pos: instanceExpr.pos,
      type: t,
      expr: instanceExpr,
      isStatic: true
    };
    out.push(instField);

    // create public static fields for each public instance var/prop
    for (f in cdef.fields) {
      if (f.isStatic) continue;
      if (f.access != Access.APublic) continue;

      switch (f.kind) {
        case (Field.FVar), Field.FProp:
          var init:Expr = macro __macro_instance.$f.name;
          var newField:Field = {
            name: f.name,
            doc: f.doc,
            meta: [],
            access: Access.APublic,
            kind: Field.FVar,
            pos: f.pos,
            type: f.type,
            expr: init,
            isStatic: true
          };
          out.push(newField);
        default:
      }
    }

    return out;
  }
}