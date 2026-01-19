function dt = getNtpTime(server, port, timeoutSecs)
% getNtpTime Query NTP server and return datetime in UTC
% dt = getNtpTime(server)               % default port=123, timeout=3s
% dt = getNtpTime(server, port, timeout) 
if nargin<2, port = 123; end
if nargin<3, timeoutSecs = 3; end

% Build 48-byte NTP request: LI=0 VN=4 Mode=3 (client) -> 0x23
req = uint8(zeros(48,1));
req(1) = uint8(0x23);

% Java UDP socket (portable across platforms)
import java.net.DatagramPacket java.net.DatagramSocket java.net.InetAddress
addr = InetAddress.getByName(server);
sock = DatagramSocket();
sock.setSoTimeout(int32(ceil(timeoutSecs*1000)));

try
    % send request
    outPacket = DatagramPacket(req, numel(req), addr, int32(port));
    sock.send(outPacket);

    % receive response (48 bytes)
    buffer = javaArray('java.lang.Byte', 48);
    recvBuf = zeros(48,1,'int8');
    respPacket = DatagramPacket(recvBuf, int32(48));
    sock.receive(respPacket);
    data = typecast(int8(respPacket.getData()), 'uint8');  % 1x48 uint8

    % Transmit Timestamp is bytes 40..47 (1-based indexing)
    ts_sec = uint64(data(41)) * 2^24 + uint64(data(42)) * 2^16 + ...
             uint64(data(43)) * 2^8  + uint64(data(44));
    ts_frac = uint64(data(45)) * 2^24 + uint64(data(46)) * 2^16 + ...
              uint64(data(47)) * 2^8  + uint64(data(48));
    ntpSeconds = double(ts_sec) + double(ts_frac) / 2^32;

    % NTP epoch starts 1900-01-01; convert to POSIX time by subtracting offset
    % offset = seconds between 1900-01-01 and 1970-01-01 = 2208988800
    posixSeconds = ntpSeconds - 2208988800;
    dt = datetime(posixSeconds, 'ConvertFrom', 'posixtime', 'TimeZone', 'UTC');
catch ME
    sock.close();
    rethrow(ME);
end

sock.close();
end

% % Usage
% t = getNtpTime('pool.ntp.org');
% disp(t);
