#!/usr/bin/env node

// Test client for workspace preview IPC

const net = require('net');
const SOCKET_PATH = '/tmp/hyprland-workspace-preview.sock';

function requestPreview(workspaceId) {
    const client = net.createConnection(SOCKET_PATH, () => {
        console.log('Connected to preview server');
        
        const request = {
            type: 'preview_request',
            workspace_id: workspaceId
        };
        
        client.write(JSON.stringify(request));
    });
    
    client.on('data', (data) => {
        console.log('Received:', data.toString());
        client.end();
    });
    
    client.on('error', (err) => {
        console.error('Connection error:', err.message);
    });
}

// Request preview for workspace 1
const workspaceId = parseInt(process.argv[2]) || 1;
console.log(`Requesting preview for workspace ${workspaceId}...`);
requestPreview(workspaceId);