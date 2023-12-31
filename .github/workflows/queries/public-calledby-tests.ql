/**
 * @description Finds all public methods that are called by test methods in TypeScript using Jest
 * @kind problem
 * @id typescript/public-methods-called-by-jest-tests
 * @problem.severity recommendation
 */

import typescript

// Predicate to identify Jest test files
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
  // In TypeScript, methods are public by default, but you can refine this as needed
  not m.isPrivate() and not m.isProtected()
}

from Method testMethod, Method publicMethod, CallExpr call
where 
    isJestTestFile(testMethod.getFile()) and
    call.getCallee().(MethodAccess).getTarget() = publicMethod and
    isPublicMethod(publicMethod) and
    call.getEnclosingCallable() = testMethod
select publicMethod, "Public method called by test method: " + testMethod.getName()
