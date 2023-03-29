const webauthnJson = require("../lib/webauthn-json-0.6.1/dist/esm/webauthn-json");

console.log("webauthnJson.supported(): " + webauthnJson.supported())
let ceremonyState = {};

function extend(obj, more) {
    return Object.assign({}, obj, more);
}

function rejectIfNotSuccess(response) {
    console.log(response);
    if (response.success) {
        return response;
    } else {
        return new Promise((resolve, reject) => reject(response));
    }
}

function rejected(err) {
    return new Promise((resolve, reject) => reject(err));
}

function setStatus(statusText) {
    document.getElementById('status').textContent = statusText;
}

function addMessage(message) {
    const el = document.getElementById('messages');
    const p = document.createElement('p');
    p.appendChild(document.createTextNode(message));
    el.appendChild(p);
}

function addMessages(messages) {
    messages.forEach(addMessage);
}

function clearMessages() {
    const el = document.getElementById('messages');
    while (el.firstChild) {
        el.removeChild(el.firstChild);
    }
}

function showJson(name, data) {
    const el = document.getElementById(name)
        .textContent = JSON.stringify(data, false, 2);
}

function showRequest(data) {
    return showJson('request', data);
}

function showAuthenticatorResponse(data) {
    const clientDataJson = data && (data.response && data.response.clientDataJSON);
    return showJson('authenticator-response', extend(
        data, {
            _clientDataJson: data && JSON.parse(new TextDecoder('utf-8').decode(base64url.toByteArray(clientDataJson))),
        }));
}

function showServerResponse(data) {
    if (data && data.messages) {
        addMessages(data.messages);
    }
    return showJson('server-response', data);
}

function hideDeviceInfo() {
    document.getElementById("device-info").style = "display: none";
}

function showDeviceInfo(params) {
    document.getElementById("device-info").style = undefined;

    if (params.displayName) {
        document.getElementById("device-name-row").style = undefined;
        document.getElementById("device-name").textContent = params.displayName;
    } else {
        document.getElementById("device-name-row").style = "display: none";
    }

    if (params.nickname) {
        document.getElementById("device-nickname-row").style = undefined;
        document.getElementById("device-nickname").textContent = params.nickname;
    } else {
        document.getElementById("device-nickname-row").style = "display: none";
    }

    if (params.imageUrl) {
        document.getElementById("device-icon").src = params.imageUrl;
    }
}

function resetDisplays() {
    clearMessages();
    showRequest(null);
    showAuthenticatorResponse(null);
    showServerResponse(null);
    hideDeviceInfo();
}

function getIndexActions() {
    return fetch('http://local.next.test.nordnet.fi/actions')
        .then(response => response.json())
        .then(data => data.actions);
}

function getRegisterRequest(urls, username, displayName, credentialNickname, requireResidentKey) {
    return fetch("http://local.next.test.nordnet.fi/register", {
        body: new URLSearchParams({
            username,
            displayName: displayName || username,
            credentialNickname,
            requireResidentKey: requireResidentKey || "preferred"
        }),
        method: 'POST',
    })
        .then(response => response.json())
        .then(rejectIfNotSuccess);
}

function executeRegisterRequest(request) {
    console.log('executeRegisterRequest', request);
    return webauthnJson.create({publicKey: request.publicKeyCredentialCreationOptions});
}

function submitResponse(url, request, response) {
    console.log('submitResponse', url, request, response);
    const body = {requestId: request.requestId, credential: response};
    return fetch(url, {
        method: 'POST',
        body: JSON.stringify(body),
    })
        .then(response => response.json());
}

async function performCeremony(params) {
    const callbacks = params.callbacks || {}; /* { init, authenticatorRequest, serverRequest } */
    const getIndexActions = params.getIndexActions; /* function(): object */
    const getRequest = params.getRequest; /* function(urls: object): { publicKeyCredentialCreationOptions: object } | { publicKeyCredentialRequestOptions: object } */
    const statusStrings = params.statusStrings; /* { init, authenticatorRequest, serverRequest, success, } */
    const executeRequest = params.executeRequest; /* function({ publicKeyCredentialCreationOptions: object } | { publicKeyCredentialRequestOptions: object }): Promise[PublicKeyCredential] */
    const handleError = params.handleError; /* function(err): ? */

    setStatus('Looking up API paths...');
    resetDisplays();

    const rootUrls = await getIndexActions();

    setStatus(statusStrings.int);
    if (callbacks.init) {
        callbacks.init(rootUrls);
    }
    const {request, actions: urls} = await getRequest(rootUrls);

    setStatus(statusStrings.authenticatorRequest);
    if (callbacks.authenticatorRequest) {
        callbacks.authenticatorRequest({request, urls});
    }
    showRequest(request);
    ceremonyState = {
        callbacks,
        request,
        statusStrings,
        urls,
    };

    const webauthnResponse = await executeRequest(request);
    return await finishCeremony(webauthnResponse);
}

async function finishCeremony(response) {
    const callbacks = ceremonyState.callbacks;
    const request = ceremonyState.request;
    const statusStrings = ceremonyState.statusStrings;
    const urls = ceremonyState.urls;

    setStatus(statusStrings.serverRequest || 'Sending response to server...');
    if (callbacks.serverRequest) {
        callbacks.serverRequest({urls, request, response});
    }
    showAuthenticatorResponse(response);

    const data = await submitResponse(urls.finish, request, response);

    if (data && data.success) {
        setStatus(statusStrings.success);
    } else {
        setStatus('Error!');
    }
    showServerResponse(data);

    return data;
}

function registerResidentKey(event) {
    return register(event, 'required');
}

async function register(event, requireResidentKey) {
    const username = document.getElementById('username').value;
    const displayName = document.getElementById('displayName').value;
    const credentialNickname = document.getElementById('credentialNickname').value;

    var request;

    try {
        const data = await performCeremony({
            getIndexActions,
            getRequest: urls => getRegisterRequest(urls, username, displayName, credentialNickname, requireResidentKey),
            statusStrings: {
                init: 'Initiating registration ceremony with server...',
                authenticatorRequest: 'Asking authenticators to create credential...',
                success: 'Registration successful!',
            },
            executeRequest: req => {
                request = req;
                return executeRegisterRequest(req);
            },
        });

        console.log("data after registration in backend: " + data)
        if (data.registration) {
            const nicknameInfo = {
                nickname: data.registration.credentialNickname,
            };

            if (data.registration && data.registration.attestationMetadata) {
                showDeviceInfo(extend(
                    data.registration.attestationMetadata.deviceProperties,
                    nicknameInfo
                ));
            } else {
                showDeviceInfo(nicknameInfo);
            }

            if (!data.attestationTrusted) {
                addMessage("Warning: Attestation is not trusted!");
            }
        }

    } catch (err) {
        console.error('Registration failed', err);
        setStatus('Registration failed.');

        if (err.name === 'NotAllowedError') {
            if (request.publicKeyCredentialCreationOptions.excludeCredentials
                && request.publicKeyCredentialCreationOptions.excludeCredentials.length > 0
            ) {
                addMessage('Credential creation failed, probably because an already registered credential is avaiable.');
            } else {
                addMessage('Credential creation failed for an unknown reason.');
            }
        } else if (err.name === 'InvalidStateError') {
            addMessage(`This authenticator is already registered for the account "${username}". Please try again with a different authenticator.`)
        } else if (err.message) {
            addMessage(`${err.name}: ${err.message}`);
        } else if (err.messages) {
            addMessages(err.messages);
        }
        return rejected(err);
    }
}

function getAuthenticateRequest(urls, username) {
    return fetch(urls.authenticate, {
        body: new URLSearchParams(username ? {username} : {}),
        method: 'POST',
    })
        .then(response => response.json())
        .then(rejectIfNotSuccess);
}

function executeAuthenticateRequest(request) {
    console.log('executeAuthenticateRequest', request);
    return webauthnJson.get({publicKey: request.publicKeyCredentialRequestOptions});
}

function authenticateWithUsername(event) {
    return authenticate(event, document.getElementById('username').value);
}

async function authenticate(event, username) {
    try {
        const data = await performCeremony({
            getIndexActions,
            getRequest: urls => getAuthenticateRequest(urls, username),
            statusStrings: {
                init: 'Initiating authentication ceremony with server...',
                authenticatorRequest: 'Asking authenticators to perform assertion...',
                success: 'Authentication successful!',
            },
            executeRequest: executeAuthenticateRequest,
        });

        if (data.registrations) {
            addMessage(`Authenticated as: ${data.registrations[0].username}`);
        }
        return data;

    } catch (err) {
        setStatus('Authentication failed.');
        if (err.name === 'InvalidStateError') {
            addMessage(`This authenticator is not registered for the account "${username}". Please try again with a registered authenticator.`)
        } else if (err.message) {
            addMessage(`${err.name}: ${err.message}`);
        } else if (err.messages) {
            addMessages(err.messages);
        }
        console.error('Authentication failed', err);
        return rejected(err);
    }
}

function deregister() {
    const credentialId = document.getElementById('deregisterCredentialId').value;
    addMessage('Deregistering credential...');

    return getIndexActions()
        .then(urls =>
            fetch(urls.deregister, {
                body: new URLSearchParams({credentialId}),
                method: 'POST',
            })
        )
        .then(response => response.json())
        .then(rejectIfNotSuccess)
        .then(data => {
            if (data.success) {
                if (data.droppedRegistration) {
                    addMessage(`Successfully deregistered credential: ${data.droppedRegistration.credentialNickname || credentialId}`);
                } else {
                    addMessage(`Successfully deregistered credential: ${credentialId}`);
                }
                if (data.accountDeleted) {
                    addMessage('No credentials remain - account deleted.');
                }
            } else {
                addMessage('Credential deregistration failed.');
            }
        })
        .catch((err) => {
            setStatus('Credential deregistration failed.');
            if (err.message) {
                addMessage(`${err.name}: ${err.message}`);
            } else if (err.messages) {
                addMessages(err.messages);
            }
            console.error('Authentication failed', err);
            return rejected(err);
        });
}

function usernameChanged(event) {
    const displayNameField = document.getElementById("displayName");
    displayNameField.placeholder = event.target.value;
}

function init() {
    hideDeviceInfo();

    document.getElementById("username").oninput = usernameChanged;
    document.getElementById("registerButton").onclick = register;
    document.getElementById("registerRkButton").onclick = registerResidentKey;
    document.getElementById("authenticateWithUsernameButton").onclick = authenticateWithUsername;
    document.getElementById("authenticateButton").onclick = authenticate;
    document.getElementById("deregisterButton").onclick = deregister;

    return false;
}

window.onload = init;
