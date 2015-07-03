#!/usr/bin/perl
# Ansible managed: /home/paulr/monoceros/ansible/common/roles/tomcat/templates/nodeStatus.pl.j2 modified on 2015-04-24 22:25:33 by paulr on dc1-ansible01
use SOAP::Lite;

my $sProtocol = "https";
my $sIf = "eth0";

my $sState = $ARGV[0];
$sIf = $ARGV[1] if $ARGV[1];
# get the gateway IP for the f5_ltm call
my $gateway = "pd4-lb01.hkg3.audsci.net";

$ENV{PATH} = '/bin:/usr/bin';

sub usage()
{
        die ("Usage: nodeStatus.pl [[enable|disable] eth] \n");
    }

chomp($gateway);
if ( !$gateway )
{
    print "SEVERE: Can't find GATEWAY address in /etc/sysconfig/network";
    return -1;
}

# get the host IP address
my $ip ='';
$ip = `/sbin/ifconfig $sIf |grep 'inet addr'|awk -F : '{ print \$2 }' | awk '{ print \$1 }'`;
chomp($ip);
if ( !$ip )
{
    print "SEVERE: Can't find host IP address.";
    return -1;
}

# the third octet of the IP address must contain a middle zero like xxx.xxx.x0x.xxx
$ip =~ s/(\d{1,3}\.\d{1,3}\.)(\d{1})(\d{1})(\d{1})(\.\d{1,3})/$1$2X$4$5/;
$ip =~ s/X/0/;

$sHost     = $gateway;
$sPort     = 443;
$sProtocol = "https";
$sNode     = $ip;
$sUID      = 'icontrol';
$sPWD      = '7SHZxLXqcX94pGZ';

sub SOAP::Transport::HTTP::Client::get_basic_credentials
{
    return "$sUID" => "$sPWD";
}

$NodeAddress = SOAP::Lite
    -> uri('urn:iControl:LocalLB/NodeAddress')
    -> readable(1)
    -> proxy("$sProtocol://$sHost:$sPort/iControl/iControlPortal.cgi");
eval { $NodeAddress->transport->http_request->header
(
    'Authorization' =>
    'Basic ' . MIME::Base64::encode("$sUID:$sPWD", '')
); };

sub SOAP::Deserializer::typecast
{
    my ($self, $value, $name, $attrs, $children, $type) = @_;
    my $retval = undef;
    if ( "{urn:iControl}Common.EnabledState" == $type )
    {
        $retval = $value;
    }
    return $retval;
}

if ( "" eq $sNode )
{
    $soapResponse = $NodeAddress->get_list();
    &checkResponse($soapResponse);

    print "Available Nodes:\n";
    my $nodeNumber = 0;
    my @node_list = @{$soapResponse->result};
    foreach my $node (@node_list)
    {
        print "\t[$nodeNumber] = '$node'\n";
        $nodeNumber++;
    }
}
else
{
    $soapResponse =
        $NodeAddress->get_session_enabled_state
        (
            SOAP::Data->name ( node_addresses => [$sNode] )
        );
    &checkResponse($soapResponse);

    @enabled_state_list = @{$soapResponse->result};
    $enabled_state = @enabled_state_list[0];

    if ( $sState eq 'disable' || $sState eq '0' )
    {
        $toggleState = "STATE_DISABLED";
    }

    if ( $sState eq 'enable' || $sState eq '1' )
    {
        $toggleState = "STATE_ENABLED";
    }

    if ( $sState eq 'status' || $sState eq '' )
    {
        print "F5_LTM Said: Node $sNode current state '$enabled_state'\n";
        exit(0);
    }

    $soapResponse =
        $NodeAddress->set_session_enabled_state
        (
            SOAP::Data->name(node_addresses => [$sNode]),
            SOAP::Data->name(states => [$toggleState])
        );
    &checkResponse($soapResponse);

    $soapResponse =
        $NodeAddress->get_session_enabled_state
        (
            SOAP::Data->name ( node_addresses => [$sNode] )
        );
    &checkResponse($soapResponse);

    @enabled_state_list = @{$soapResponse->result};
    $new_enabled_state = $enabled_state_list[0];

    print "F5_LTM Said: Node $sNode state set from '$enabled_state' to '$new_enabled_state'\n";
    if ( $new_enabled_state eq $toggleState )
        { exit(0); }
    else
        { exit(1); }
}

sub checkResponse()
{
    my ($soapResponse) = (@_);
    if ( $soapResponse->fault )
    {
        print $soapResponse->faultcode, " ", $soapResponse->faultstring, "\n";
        exit(1);
    }
}
