
void validate(input, schema) {
  print("validating");
  validateInternal(input, schema, "");
  print("done");
}

void validateInternal(input, schema, path) {
  hasAllRequired(input, schema, path);
  hasNoExtra(input, schema, path);
  validateFields(input, schema, path);
}

void hasAllRequired(input, schema, path) {
  for(var field in schema.getKeys()) {
    var def = schema[field];
    if (def['required'] && !input.containsKey(field)) {
      print("${path}: MUST have field ${field} (${schema[field]['description']}) of type ${schema[field]['type']}.");
    }
  }
}

void hasNoExtra(input, schema, path) {
  for (var f in input.getKeys()) {
    if (!schema.containsKey(f)) {
      print("${path}.${f}: SHOULD be removed.");
    }
  }
}

void validateFields(input, schema, path) {
  for (var field in schema.getKeys()) {
    if (input.containsKey(field)) {
      validateType(input[field], schema[field], path + "." + field);
    }
  }
}

void validateType(field, def, path) {
  var ty = def['type'];
  if (field is String && ty == "string") {
    validateString(field, def, path);
  } else if (field is int && ty == "integer") {
    validateInteger(field, def, path);
  } else if (field is List && ty == "array") {
    validateArray(field, def, path);
  } else if (field is num && ty == "number") {
  } else if (field is Object && ty == "object") {
    validateObject(field, def, path);
  } else if (field is bool && ty == "boolean") {
    validateBool(field, def, path);
  } else if (ty == "any") {
    // Already all good...
  } else {
    print("${path}: MUST be of type ${ty}.");
  }
}

void validateString(field, def, path) {
  if (def.containsKey("enum")) {
    if (def["enum"].indexOf(field) == -1) {
      print("${path}: MUST be in ${def["enum"]}");
    }
  }
}

void validateInteger(field, def, path) {
}

void validateArray(field, def, path) {
  if(def.containsKey("minItems")
      && field.length < def["minItems"]) {
    print("${path}: MUST have at least ${def["minItems"]} items");
  }
  if (def.containsKey("items")) {
    var sc = def["items"];
    for(var i = 0; i < field.length; ++i) {
      validateType(field[i], sc, path + "[" + i + "]");
    }
  }
}

void validateObject(field, def, path) {
  if (def.containsKey("properties")) {
    validateInternal(field, def["properties"], path);
  }
}

void validateBool(field, def, path) {
}
