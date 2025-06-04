#!/usr/bin/env node

// Test client for workspace preview IPC - v3 with image support

const net = require('net');
const fs = require('fs');
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
    
    let responseData = '';
    
    client.on('data', (chunk) => {
        responseData += chunk.toString();
    });
    
    client.on('end', () => {
        try {
            const response = JSON.parse(responseData);
            console.log('Response:', {
                type: response.type,
                workspace_id: response.workspace_id,
                status: response.status,
                width: response.width,
                height: response.height,
                format: response.format,
                timestamp: response.timestamp,
                data_length: response.data ? response.data.length : 0
            });
            
            if (response.status === 'success' && response.data) {
                // Save the image
                const imageData = Buffer.from(response.data, 'base64');
                const filename = `workspace-${workspaceId}-preview.png`;
                fs.writeFileSync(filename, imageData);
                console.log(`Preview saved to ${filename}`);
            }
        } catch (err) {
            console.error('Failed to parse response:', err);
            console.log('Raw response:', responseData);
        }
    });
    
    client.on('error', (err) => {
        console.error('Connection error:', err.message);
    });
}

// Request preview for workspace
const workspaceId = parseInt(process.argv[2]) || 1;
console.log(`Requesting preview for workspace ${workspaceId}...`);
requestPreview(workspaceId);