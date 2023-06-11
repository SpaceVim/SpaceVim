local LSP = require('cmp_dictionary.kit.LSP')
local AsyncTask = require('cmp_dictionary.kit.Async.AsyncTask')

---@class cmp_dictionary.kit.LSP.Client
---@field public client table
local Client = {}
Client.__index = Client

---Create LSP Client wrapper.
---@param client table
---@return cmp_dictionary.kit.LSP.Client
function Client.new(client)
  local self = setmetatable({}, Client)
  self.client = client
  return self
end

---@param params cmp_dictionary.kit.LSP.ImplementationParams
function Client:textDocument_implementation(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/implementation', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.TypeDefinitionParams
function Client:textDocument_typeDefinition(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/typeDefinition', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params nil
function Client:workspace_workspaceFolders(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/workspaceFolders', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@class cmp_dictionary.kit.LSP.IntersectionType01 : cmp_dictionary.kit.LSP.ConfigurationParams, cmp_dictionary.kit.LSP.PartialResultParams

---@param params cmp_dictionary.kit.LSP.IntersectionType01
function Client:workspace_configuration(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/configuration', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DocumentColorParams
function Client:textDocument_documentColor(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/documentColor', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.ColorPresentationParams
function Client:textDocument_colorPresentation(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/colorPresentation', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.FoldingRangeParams
function Client:textDocument_foldingRange(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/foldingRange', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DeclarationParams
function Client:textDocument_declaration(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/declaration', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.SelectionRangeParams
function Client:textDocument_selectionRange(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/selectionRange', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.WorkDoneProgressCreateParams
function Client:window_workDoneProgress_create(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('window/workDoneProgress/create', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CallHierarchyPrepareParams
function Client:textDocument_prepareCallHierarchy(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/prepareCallHierarchy', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CallHierarchyIncomingCallsParams
function Client:callHierarchy_incomingCalls(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('callHierarchy/incomingCalls', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CallHierarchyOutgoingCallsParams
function Client:callHierarchy_outgoingCalls(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('callHierarchy/outgoingCalls', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.SemanticTokensParams
function Client:textDocument_semanticTokens_full(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/semanticTokens/full', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.SemanticTokensDeltaParams
function Client:textDocument_semanticTokens_full_delta(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/semanticTokens/full/delta', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.SemanticTokensRangeParams
function Client:textDocument_semanticTokens_range(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/semanticTokens/range', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params nil
function Client:workspace_semanticTokens_refresh(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/semanticTokens/refresh', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.ShowDocumentParams
function Client:window_showDocument(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('window/showDocument', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.LinkedEditingRangeParams
function Client:textDocument_linkedEditingRange(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/linkedEditingRange', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CreateFilesParams
function Client:workspace_willCreateFiles(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/willCreateFiles', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.RenameFilesParams
function Client:workspace_willRenameFiles(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/willRenameFiles', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DeleteFilesParams
function Client:workspace_willDeleteFiles(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/willDeleteFiles', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.MonikerParams
function Client:textDocument_moniker(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/moniker', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.TypeHierarchyPrepareParams
function Client:textDocument_prepareTypeHierarchy(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/prepareTypeHierarchy', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.TypeHierarchySupertypesParams
function Client:typeHierarchy_supertypes(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('typeHierarchy/supertypes', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.TypeHierarchySubtypesParams
function Client:typeHierarchy_subtypes(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('typeHierarchy/subtypes', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.InlineValueParams
function Client:textDocument_inlineValue(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/inlineValue', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params nil
function Client:workspace_inlineValue_refresh(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/inlineValue/refresh', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.InlayHintParams
function Client:textDocument_inlayHint(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/inlayHint', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.InlayHint
function Client:inlayHint_resolve(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('inlayHint/resolve', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params nil
function Client:workspace_inlayHint_refresh(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/inlayHint/refresh', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DocumentDiagnosticParams
function Client:textDocument_diagnostic(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/diagnostic', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.WorkspaceDiagnosticParams
function Client:workspace_diagnostic(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/diagnostic', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params nil
function Client:workspace_diagnostic_refresh(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/diagnostic/refresh', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.RegistrationParams
function Client:client_registerCapability(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('client/registerCapability', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.UnregistrationParams
function Client:client_unregisterCapability(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('client/unregisterCapability', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.InitializeParams
function Client:initialize(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('initialize', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params nil
function Client:shutdown(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('shutdown', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.ShowMessageRequestParams
function Client:window_showMessageRequest(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('window/showMessageRequest', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.WillSaveTextDocumentParams
function Client:textDocument_willSaveWaitUntil(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/willSaveWaitUntil', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CompletionParams
function Client:textDocument_completion(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/completion', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CompletionItem
function Client:completionItem_resolve(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('completionItem/resolve', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.HoverParams
function Client:textDocument_hover(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/hover', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.SignatureHelpParams
function Client:textDocument_signatureHelp(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/signatureHelp', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DefinitionParams
function Client:textDocument_definition(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/definition', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.ReferenceParams
function Client:textDocument_references(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/references', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DocumentHighlightParams
function Client:textDocument_documentHighlight(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/documentHighlight', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DocumentSymbolParams
function Client:textDocument_documentSymbol(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/documentSymbol', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CodeActionParams
function Client:textDocument_codeAction(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/codeAction', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CodeAction
function Client:codeAction_resolve(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('codeAction/resolve', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.WorkspaceSymbolParams
function Client:workspace_symbol(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/symbol', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.WorkspaceSymbol
function Client:workspaceSymbol_resolve(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspaceSymbol/resolve', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CodeLensParams
function Client:textDocument_codeLens(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/codeLens', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.CodeLens
function Client:codeLens_resolve(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('codeLens/resolve', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params nil
function Client:workspace_codeLens_refresh(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/codeLens/refresh', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DocumentLinkParams
function Client:textDocument_documentLink(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/documentLink', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DocumentLink
function Client:documentLink_resolve(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('documentLink/resolve', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DocumentFormattingParams
function Client:textDocument_formatting(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/formatting', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DocumentRangeFormattingParams
function Client:textDocument_rangeFormatting(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/rangeFormatting', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.DocumentOnTypeFormattingParams
function Client:textDocument_onTypeFormatting(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/onTypeFormatting', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.RenameParams
function Client:textDocument_rename(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/rename', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.PrepareRenameParams
function Client:textDocument_prepareRename(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('textDocument/prepareRename', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.ExecuteCommandParams
function Client:workspace_executeCommand(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/executeCommand', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

---@param params cmp_dictionary.kit.LSP.ApplyWorkspaceEditParams
function Client:workspace_applyEdit(params)
  local that, request_id, reject_ = self, nil, nil
  local task = AsyncTask.new(function(resolve, reject)
    request_id = self.client.request('workspace/applyEdit', params, function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    reject_ = reject
  end)
  function task.cancel()
    that.client.cancel_request(request_id)
    reject_(LSP.ErrorCodes.RequestCancelled)
  end
  return task
end

return Client
