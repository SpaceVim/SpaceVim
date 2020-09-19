Error ASTNodeImporter::ImportFunctionDeclBody(FunctionDecl *FromFD,
                                              FunctionDecl *ToFD) {
  if (Stmt *FromBody = FromFD->getBody()) {
    if (ExpectedStmt ToBodyOrErr = import(FromBody))
      ToFD->setBody(*ToBodyOrErr);
    else
      return ToBodyOrErr.takeError();
  }
  return Error::success();
}

