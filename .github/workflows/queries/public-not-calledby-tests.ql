/**
 * @description Finds all public methods that are not called by any test methods
 * @kind problem
 * @id typescript/uncalled-public-methods
 * @problem.severity recommendation
 */

import javascript

// Predicate to identify test files (assumes file naming convention for Jest tests)
predicate isTest(Function test) {
  exists(CallExpr describe, CallExpr it |
    describe.getCalleeName() = "describe" and
    it.getCalleeName() = "it" and
    it.getParent*() = describe and
    test = it.getArgument(1)
  )
}

// Predicate to identify public methods in TypeScript
predicate isPublicMethod(Method m) {
  not m.isPrivate() and not m.isProtected()
}

from Method publicMethod
where 
    isPublicMethod(publicMethod) and
    not exists(CallExpr call |
      call.getCallee() = publicMethod and
      isTestFile(call.getFile())
    )
select publicMethod, "Public method not called by any test: " + publicMethod.getName()
