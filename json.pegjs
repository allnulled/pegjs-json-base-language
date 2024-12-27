{
  // Función auxiliar para convertir cadenas con escapes
  function unescapeString(str) {
    return JSON.parse(str);
  }
}

Start
  = value:Value { return value; }

Value
  = Object
  / Array
  / String
  / Number
  / Boolean
  / Null

Object
  = "{" _ members:MemberList? _ "}" {
      return members !== null ? members : {};
    }

MemberList
  = head:Member tail:(_ "," _ Member)* {
      const result = { [head.key]: head.value };
      tail.forEach(({ key, value }) => {
        result[key] = value;
      });
      return result;
    }

Member
  = key:String _ ":" _ value:Value {
      return { key, value };
    }

Array
  = "[" _ elements:ElementList? _ "]" {
      return elements !== null ? elements : [];
    }

ElementList
  = head:Value tail:(_ "," _ Value)* {
      return [head, ...tail.map(e => e[3])];
    }

String
  = '"' chars:DoubleQuotedString '"' {
      return text();
    }

DoubleQuotedString
  = chars:(([^"\\] / "\\") .)* { return chars.join(""); }

Number
  = value:$("-"? [0-9]+ ("." [0-9]+)? ([eE] [-+]? [0-9]+)?) {
      return parseFloat(value);
    }

Boolean
  = "true" { return true; }
  / "false" { return false; }

Null
  = "null" { return null; }

_ "whitespace"
  = [ \t\n\r]*
