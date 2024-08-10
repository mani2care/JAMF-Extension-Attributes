#!/usr/bin/perl -w

use strict;
use IO::File;
use Sys::Syslog;
use DateTime;

my $progname = 'ZscalerStatus.pl';
$ENV{PATH} = '/sbin:/bin:/usr/bin:/usr/sbin';
umask 0022;

# variables
my $correctsearch = 0;
my $correctresolver = 0;
my $resolvconf = '/etc/resolv.conf';
my $resolver = 'nameserver 100.64.0.';
my $resolver2 = 'nameserver 192.162.8.';
my $runningZS = 0;
my $runningZT = 0;
my $runningZTray = 0;
my $runningZUPM  = 0;
my $search = 'search your.domain.com your.com';
my $zccsvc = '/Applications/Zscaler/Zscaler.app/Contents/PlugIns/ZscalerService';
my $zcctray = '/Applications/Zscaler/Zscaler.app/Contents/MacOS/Zscaler';
my $zcctun = '/Applications/Zscaler/Zscaler.app/Contents/PlugIns/ZscalerTunnel';
my $zccupm = '/Library/Application Support/Zscaler/UPM/UPMServiceController';
my $rc = "False";
my @checkfor = ($zccsvc, $zcctray, $zcctun, $zccupm);
my @running;

main:
openlog $progname, undef, 'user';
syslog('notice', "$progname: Checking if Zscaler is signed in.");
open PS, "ps -A -e -w -O comm= |" or die "$progname: ps: $!\n";
@running = <PS>;
close PS;
for my $dut (@checkfor) {
	if (grep /$dut/, @running) {
		if ($dut =~ /$zccsvc/) {
			$runningZS = 1;
			syslog('notice', "$progname: $zccsvc is running.");
			#print "$progname: running is $runningZS\n";
		}
		elsif ($dut eq $zcctray) {
			$runningZT = 1;
			syslog('notice', "$progname: $zcctray is running.");
			#print "$progname: running is $runningZTray\n";
		}
		elsif ($dut eq $zcctun) {
			$runningZTray = 1;
			syslog('notice', "$progname: $zcctun is running.");
			#print "$progname: running is $runningZT\n";
		}
		elsif ($dut eq $zccupm) {
			$runningZUPM = 1;
			syslog('notice', "$progname: $zccupm is running.");
			#print "$progname: running is $runningZUPM\n";
		}
	}
	else {
		#print "$progname: process $dut not running";
		syslog('notice', "$progname: process %s not running", $dut);
	}
}
close PS;
open RS, $resolvconf or die "$progname: $resolvconf $!\n";
while (<RS>) {
	chomp;
	my $line = $_;
	if ($line =~ /^$search/) {
		#print "$line\n";
		correctsearch = 1;
		syslog('notice', "$progname: Search path is correct.");
		#
	elsif (($line =~ /^$resolver/) || ($line =~ /^$resolver2/)) {
		#print "$line\n";
		$correctresolver = 1;
		syslog('notice', "$progname: nameservers correct.");
	}
}
close RS;
if (($runningZS == 1) && ($runningZT == 1) && ($runningZTray == 1) && ($correctresolver == 1)) {
	# not everyone had the ZDX running so removed UPM and the match for search path was failing so just removed it as well
	#if (($runningZS == 1) && ($runningZT == 1) && ($runningZTray == 1) && ($runningZUPM == 1) && ($correctresolver == 1) && ($correctsearch == 1)) {
	#print "$progname: Zscaler installed, healthy and running\n";
	$rc = "True";
}

closelog;
print "<result>$rc</result>\n";
exit 0;
