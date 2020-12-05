using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Concurrent;
using System.Net.WebSockets;
using System.Threading;

namespace webserver.Middelware
{
    public class WebSocketConnectionManager
    {
        private ConcurrentDictionary<string, WebSocket> _sockets = new ConcurrentDictionary<string, WebSocket>();
        
        public ConcurrentDictionary<string, WebSocket> GetAllSockets()
        {
            return _sockets;
        }

        public string AddSocket(WebSocket socket)
        {
            string ConnID = Guid.NewGuid().ToString(); // Create new uniqe identitifer
            _sockets.TryAdd(ConnID, socket); // Add new connection to dictionary
            Console.WriteLine("Connection Added: " + ConnID);
            return ConnID;
        }

        public WebSocket RemoveSocket(WebSocket socket)
        {
            string id = GetAllSockets().FirstOrDefault(s => s.Value == socket).Key; // Find the websocket in the dictionary
            GetAllSockets().TryRemove(id, out WebSocket sock); // Remove from dictionary
            return sock;
        }

        // TODO: Get input ID of socket and return it
        public WebSocket FindSocket()
        {
            try
            {
                //TODO: Implement this when webserver is able to handle multiple worlds
                return GetAllSockets().First().Value;
            }
            catch(Exception e)
            {
                throw new Exception("WebSocketManager FindSocket: " + e.Message);
            }
        }
    }
}
