//1. Активация системного расширения
let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier:extensionIdentifier, queue:.main);
request.delegate = self;
OSSystemExtensionManager.shared.submitRequest(request);

//2. Обработка результатов запроса на активацию
func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error)
{
	os_log("System extension request failed %@", error.localizedDescription);
}
func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) 
{
	os_log("System extension requires user approval") 
}
func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension extension: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction 
{
	os_log("Replacing extension: %@ %@", existing, extension);
	return .replace;
}    
func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result)
{
	os_log("System extension activating request result: %d", result.rawValue) 
}

//1. Регистрация клиента и установка обработчика сообщений
var client: OpaquePointer?;
let result = es_new_client(&client){ (client, message) in handle_event_message(message); }

func handle_event_message(_ msg: UnsafePointer<es_message_t>) 
{
	if ES_EVENT_TYPE_NOTIFY_EXEC != msg.pointee.event_type
	{
		return
	}
	if let process = msg.pointee.process 
	{        
		os_log("PID: %d", audit_token_to_pid(process.pointee.audit_token));
		os_log("PPID: %d", process.pointee.ppid)           
		if let executable = process.pointee.executable
		{
			os_log("Process file path: %{public}@", String(cString: executable.pointee.path.data))         
		}    
	}
}


//2. Подписка клиентов на события
if let client = client 
{
	let cacheResult = es_clear_cache(client);
	if cacheResult != ES_CLEAR_CACHE_RESULT_SUCCESS 
	{
		fatalError("Failed to clear cache")  
	}
	var events = [ ES_EVENT_TYPE_NOTIFY_EXEC ];
	let ret = es_subscribe(client, &events, UInt32(events.count));
	if ret != ES_RETURN_SUCCESS 
	{
		fatalError("Failed to subscribe events")
	}
}

//3. Отписка и освобождение клиентов
if let client = client 
{
	es_unsubscribe_all(client);
	es_delete_client(client); 
}