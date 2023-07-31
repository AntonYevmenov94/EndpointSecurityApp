/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Functions that initialize the Endpoint Security system extension to receive NOTIFY events.
*/

#include <EndpointSecurity/EndpointSecurity.h>
#include <dispatch/dispatch.h>
#include <bsm/libbsm.h>
#include <stdio.h>
#include <os/log.h>

static void
handle_event(es_client_t *client, const es_message_t *msg)
{
	switch (msg->event_type) {
		case ES_EVENT_TYPE_NOTIFY_EXEC:
			os_log(OS_LOG_DEFAULT, "%{public}s (pid: %d) | EXEC: New image: %{public}s",
				msg->process->executable->path.data,
				audit_token_to_pid(msg->process->audit_token),
				msg->event.exec.target->executable->path.data);
			break;

		case ES_EVENT_TYPE_NOTIFY_FORK:
			os_log(OS_LOG_DEFAULT, "%{public}s (pid: %d) | FORK: Child pid: %d",
				msg->process->executable->path.data,
				audit_token_to_pid(msg->process->audit_token),
				audit_token_to_pid(msg->event.fork.child->audit_token));
			break;

		case ES_EVENT_TYPE_NOTIFY_EXIT:
			os_log(OS_LOG_DEFAULT, "%{public}s (pid: %d) | EXIT: status: %d",
				msg->process->executable->path.data,
				audit_token_to_pid(msg->process->audit_token),
				msg->event.exit.stat);
			break;

		default:
			os_log_error(OS_LOG_DEFAULT, "Unexpected event type encountered: %d\n", msg->event_type);
			break;
	}
}

int
main(int argc, char *argv[])
{
	es_client_t *client;
	es_new_client_result_t result = es_new_client(&client, ^(es_client_t *c, const es_message_t *msg) {
		handle_event(c, msg);
	});

	if (result != ES_NEW_CLIENT_RESULT_SUCCESS) {
		os_log_error(OS_LOG_DEFAULT, "Failed to create new ES client: %d", result);
		return 1;
	}

	es_event_type_t events[] = { ES_EVENT_TYPE_NOTIFY_EXEC, ES_EVENT_TYPE_NOTIFY_FORK, ES_EVENT_TYPE_NOTIFY_EXIT };

	if (es_subscribe(client, events, sizeof(events) / sizeof(events[0])) != ES_RETURN_SUCCESS) {
		os_log_error(OS_LOG_DEFAULT, "Failed to subscribe to events");
		es_delete_client(client);
		return 1;
	}

	dispatch_main();

	return 0;
}


let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier:extensionIdentifier, queue:.main);
request.delegate = self OSSystemExtensionManager.shared.submitRequest(request);

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