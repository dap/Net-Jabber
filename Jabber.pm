##############################################################################
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Library General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Library General Public License for more details.
#
#  You should have received a copy of the GNU Library General Public
#  License along with this library; if not, write to the
#  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
#  Boston, MA  02111-1307, USA.
#
#  Jabber
#  Copyright (C) 1998-1999 The Jabber Team http://jabber.org/
#
##############################################################################

package Net::Jabber;

=head1 NAME

Net::Jabber - Jabber Perl Library

=head1 SYNOPSIS

  Net::Jabber provides a Perl user with access to the Jabber
  Instant Messaging protocol.

  For more information about Jabber visit:

    http://www.jabber.org

=head1 DESCRIPTION

  Net::Jabber is a convenient tool to use for any perl script
  that would like to utilize the Jabber Instant Messaging
  protocol.  While not a client in and of itself, it provides
  all of the necessary back-end functions to make a CGI client
  or command-line perl client feasible and easy to use.
  Net::Jabber is a wrapper around the rest of the official
  Net::Jabber::xxxxxx packages.

  There is are example scripts in the example directory that
  provide you with examples of very simple Jabber programs.

=head1 EXAMPLES

  In an attempt to cut down on memory usage, not all of the modules
  are loaded at compile time.  You have to tell the Net::Jabber
  module which "set" of modules you want to work with when you
  use the module:

    use Net::Jabber qw(Client Component Server);

  Depending on what you are trying to write, specify one of the
  above when you use the module.  (You can specify more than one,
  but it is unlikely that you will need too.)

    For a client:
      use Net::Jabber qw(Client);
      my $client = new Net::Jabber::Client();

    For a component:
      use Net::Jabber qw(Component);
      my $component = new Net::Jabber::Component();

    For a server:
      use Net::Jabber qw(Server);
      my $server = new Net::Jabber::Server();

=head1 METHODS

  The Net::Jabber module does not define any methods that you will call
  directly in your code.  Instead you will instantiate objects that
  call functions from this module to do work.  The three main objects
  that you will work with are the Message, Presence, and IQ modules.
  Each one corresponds to the Jabber equivilant and allows you get and
  set all parts of those packets.

  There are a few functions that are the same across all of the objects:

=head2 Retrieval functions

  GetXML() - returns the XML string that represents the data contained
             in the object.

             $xml  = $obj->GetXML();

  GetX()          - returns an array of Net::Jabber::X objects that
  GetX(namespace)   represent all of the <x/> style namespaces in the
                    object.  If you specify a namespace then only X
                    objects with that XMLNS are returned.

                    @xObj = $obj->GetX();
                    @xObj = $obj->GetX("my:namespace");

=head2 Creation functions

  NewX(namespace)     - creates a new Net::Jabber::X object with the
  NewX(namespace,tag)   specified namespace and root tag of <x/>.
                        Optionally you may specify another root tag
                        if <x/> is not desired.

                        $xObj = $obj->NewX("my:namespace");
                        $xObj = $obj->NewX("my:namespace","foo");
                          ie. <foo xmlns='my:namespace'...></foo>

=head2 Test functions

  DefinedX()          - returns 1 if there are any <x/> tags in the
  DefinedX(namespace)   packet, 0 otherwise.  Optionally you can
                        specify a namespace and determine if there
                        are any <x/> with that namespace.

                        $test = $obj->DefinedX();
                        $test = $obj->DefinedX("my:namespace");

=head1 PACKAGES

  For more information on each of these packages, please see
  the man page for each one.

  Net::Jabber::Client - this package contains the code needed to
  communicate with a Jabber server: login, wait for messages,
  send messages, and logout.  It uses XML::Stream to read the
  stream from the server and based on what kind of tag it
  encounters it calls a function to handle the tag.

  Net::Jabber::Component - this package contains the code needed
  to write a server component.  A component is a program tha handles
  the communication between a jabber server and some outside
  program or communications pacakge (IRC, talk, email, etc...)
  With this module you can write a full component in just
  a few lines of Perl.  It uses XML::Stream to communicate with
  its host server and based on what kind of tag it encounters it
  calls a function to handle the tag.

  Net::Jabber::Server - this package contains the code needed
  to instantiate a lightweight Jabber server.  This module is
  still under development, but the goal is to have this be a
  fully functioning Jabber server that can interact with a real
  server using the server to server protocol, as well as accept
  client and component connections.  The purpose being that some
  programs might be better suited if they ran and did all of the
  talking on their own.  Also this just seemed like a really cool
  thing to try and do.

  Net::Jabber::Protocol - a collection of high-level functions
  that Client, Component, and Server use to make their lives easier.
  These functions are included through AUTOLOAD.

  Net::Jabber::JID - the Jabber IDs consist of three parts:
  user id, server, and resource.  This module gives you access
  to those components without having to parse the string
  yourself.

  Net::Jabber::Message - everything needed to create and read
  a <message/> received from the server.

  Net::Jabber::Presence - everything needed to create and read
  a <presence/> received from the server.

  Net::Jabber::IQ - IQ is a wrapper around a number of modules
  that provide support for the various Info/Query namespaces that
  Jabber recognizes.

  Net::Jabber::Query - this module represents anything that can
  be called a <query/> for an <iq/>.

  Net::Jabber::X - this module represents anything that can
  be called an <x/>.

=head1 ADD CUSTOM MODULES

  The way that this module set is coded is a little different than
  the typical module.  Since XML is a very structured thing, and
  Jabber is an XML stream the modules have been coded to reuse
  code where ever possible.  Generic functions in Jabber.pm provide
  access for all of the other modules which drive the functions via
  hash structures that define the functions using AUTOLOAD.  Confused?
  I can understand if you are, I was too while trying to code this.
  But after I got the hang of it is really simple to add in a new
  Jabber module.

  For more information on this topic, please read the man page for
  Net::Jabber::Namespaces.

=head1 AUTHOR

By Ryan Eatmon in May of 2001 for http://jabber.org/

=head1 COPYRIGHT

This module is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.005;
use strict;
use Time::Local;
use Carp;
use Digest::SHA1;
use Unicode::String;
use POSIX;
use vars qw($VERSION $DEBUG %CALLBACKS $TIMEZONE $PARSING);

if (eval "require Time::Timezone") {
  $TIMEZONE = 1;
  Time::Timezone->import(qw(tz_local_offset tz_name));
} else {
  $TIMEZONE = 0;
}

$VERSION = "1.0023";

use Net::Jabber::Debug;
($Net::Jabber::JID::VERSION < $VERSION) &&
  croak("Net::Jabber::JID $VERSION required--this is only version $Net::Jabber::JID::VERSION");

use Net::Jabber::JID;
($Net::Jabber::JID::VERSION < $VERSION) &&
  croak("Net::Jabber::JID $VERSION required--this is only version $Net::Jabber::JID::VERSION");

use Net::Jabber::X;
($Net::Jabber::X::VERSION < $VERSION) &&
  croak("Net::Jabber::X $VERSION required--this is only version $Net::Jabber::X::VERSION");

use Net::Jabber::Query;
($Net::Jabber::Query::VERSION < $VERSION) &&
  croak("Net::Jabber::Query $VERSION required--this is only version $Net::Jabber::Query::VERSION");

use Net::Jabber::Message;
($Net::Jabber::Message::VERSION < $VERSION) &&
  croak("Net::Jabber::Message $VERSION required--this is only version $Net::Jabber::Message::VERSION");

use Net::Jabber::IQ;
($Net::Jabber::IQ::VERSION < $VERSION) &&
  croak("Net::Jabber::IQ $VERSION required--this is only version $Net::Jabber::IQ::VERSION");

use Net::Jabber::Presence;
($Net::Jabber::Presence::VERSION < $VERSION) &&
  croak("Net::Jabber::Presence $VERSION required--this is only version $Net::Jabber::Presence::VERSION");

use Net::Jabber::Protocol;
($Net::Jabber::Protocol::VERSION < $VERSION) &&
  croak("Net::Jabber::Protocol $VERSION required--this is only version $Net::Jabber::Protocol::VERSION");

$DEBUG = new Net::Jabber::Debug(usedefault=>1,
				header=>"NJ::Main");

require Exporter;
my @ISA = qw(Exporter);
my @EXPORT_OK = qw(Client Component Server);

sub import {
  my $class = shift;

  my $pass = 0;
  foreach my $module (@_) {
    eval "use Net::Jabber::$module;";
    croak($@) if ($@);
    eval "(\$Net::Jabber::${module}::VERSION < \$VERSION) && croak(\"Net::Jabber::$module \$VERSION required--this is only version \$Net::Jabber::${module}::VERSION\");";
    croak($@) if ($@);
    $pass = 1;
  }
  croak("Failed to load any schema for Net::Jabber from the use line.\n  ie. \"use Net::Jabber qw( Client );\"\n") if ($pass == 0);
}


##############################################################################
#
# DEBUG - helper function for printing debug messages using Net::Jabber::Debug
#
##############################################################################
sub DEBUG {
  my $self = shift;
  return $DEBUG->Log99($self->{DEBUGHEADER},": ",@_);
}


##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for debugging
#
##############################################################################
sub debug {
  my $self = shift;

  print "debug ",$self,":\n";
  &Net::Jabber::printData("debug: \$self->{DATA}->",$self->{DATA});
  &Net::Jabber::printData("debug: \$self->{CHILDREN}->",$self->{CHILDREN});
}


##############################################################################
#
# MissingFunction - send an error if the function is missing.
#
##############################################################################
sub MissingFunction {
  my ($parent,$function) = @_;
  croak("Undefined function $function in package ".ref($parent));
}


##############################################################################
#
# Get - returns the value stored in the hash
#
##############################################################################
sub Get {
  my $self = shift;
  my $args = shift;
  my $funcs = shift;

  my $arg0 = "";
  my $arg1 = "";
  $arg0 = $_[0] if ($#_ >= 0);
  $arg1 = $_[1] if ($#_ >= 1);

  my $xmlns = ((ref($args) eq "ARRAY") ? $$args[1] : "");
  my $key = ((ref($args) eq "ARRAY") ? $$args[0] : $args);

  return if ($key eq "");

  if ($key eq "__netjabber__:master") {
    #print "self($self)\n";
    #$self->debug();

    my %hash;
    foreach my $func (@{$funcs}) {
      next if ($func eq "XMLNS");
      #print "GetMaster: func($func)\n";
      my $lcfunc = lc($func);
      next unless eval "\$self->Defined$func();";
      my $value = eval "\$self->Get$func();";
      $hash{$lcfunc} = $value;
    }
    return %hash;
  }	

  my $loc = "DATA";
  if ($key =~ /^__netjabber__\:children\:(.*)$/) {
    $key = $1;
    $loc = "CHILDREN";
  }

  return unless exists($self->{$loc}->{$key});

  if (ref($self->{$loc}->{$key}) eq "Net::Jabber::JID") {
    my $value = $self->{$loc}->{$key};
    return $value->GetJID("full") if ($arg0 ne "jid");
    return $value;
  }
  if (ref($self->{$loc}->{$key}) eq "ARRAY") {
    return $self->{$loc}->{$key}->[0]
      if (($key eq "query") && ($xmlns eq "") && ($arg0 eq ""));
    if ($arg0 ne "") {
      my @list;
      foreach my $item (@{$self->{$loc}->{$key}}) {
	push(@list,$item) if ($item->GetXMLNS() eq $arg0);
      }
      return @list;
    }
    if ($xmlns ne "") {
      if (($key eq "x") || ($key eq "query")) {
	my @list;
	foreach my $item (@{$self->{$loc}->{$key}}) {
	  push(@list,$item) if ($item->GetXMLNS() eq $xmlns);
	}
	return @list;
      }
      return;
    }
    return @{$self->{$loc}->{$key}};
  }
  if (ref($self->{$loc}->{$key}) eq "HASH") {
    return if (($arg0 ne "") && !exists($self->{$loc}->{$key}->{$arg0}));
    return $self->{$loc}->{$key}->{$arg0}
      if (($arg0 ne "") && exists($self->{$loc}->{$key}->{$arg0}));
    return %{$self->{$loc}->{$key}};
  }

  return $self->{$loc}->{$key};
}


##############################################################################
#
# Defined - returns 1 if the hash element exists, 0 otherwise
#
##############################################################################
sub Defined {
  my $self = shift;
  my $key = shift;
  my $funcs = shift;
  my $xmlns = shift;

  my $loc = "DATA";
  if ($key =~ /^__netjabber__\:children\:(.*)$/) {
    $key = $1;
    $loc = "CHILDREN";
  }

  $xmlns = "" unless (defined($xmlns) &&
		      (($key eq "x") || ($key eq "query")|| ($key eq "data")));

  return exists($self->{$loc}->{$key}) if ($xmlns eq "");
  foreach my $x (@{$self->{$loc}->{$key}}) {
    return 1 if ($x->GetXMLNS() eq $xmlns);
  }
  return 0;
}


##############################################################################
#
# Set - takes an argument list and based off of it, sets the hash value.
#
##############################################################################
sub Set {
  my $self = shift;
  my $args = shift;
  my $funcs = shift;
  my $type = $$args[0];
  my $key = $$args[1];
  $key = "" unless defined($key);

  my $arg0 = "";
  my $arg1 = "";
  $arg0 = $_[0] if ($#_ >= 0);
  $arg1 = $_[1] if ($#_ >= 1);

  #&DEBUG($self,"Set: type($type) key($key) args(",join(",",@_),")");

  if ($type eq "scalar") {
    $self->{DATA}->{$key} = shift;
  }
  if ($type eq "array") {
    my(@value) = @_;
    @value = @{$value[0]} if (ref($value[0]) eq "ARRAY");
    foreach my $item (@value) {
      push(@{$self->{DATA}->{$key}},$item)
    }
    return;
  }
  if ($type eq "jid") {
    my $value = shift;
    $value = new Net::Jabber::JID($value)
      unless (ref($value) eq "Net::Jabber::JID");
    $self->{DATA}->{$key} = $value;
    return;
  }
  if ($type eq "timestamp") {
    my $stamp = shift;
    $stamp = "" unless defined($stamp);
    if ($stamp eq "") {
      $stamp = &Net::Jabber::GetTimeStamp("utc","","stamp");
    }
    $self->{DATA}->{$key} = $stamp;
    return;
  }
  if ($type eq "flag") {
    $self->{DATA}->{$key} = "";
    return;
  }
  if ($type eq "add") {
    my (@children) = @_;

    #&DEBUG($self,"Set: add args(",join(",",@children),")");
    #&DEBUG($self,"Set: add start");
    my %ignore;
    foreach my $index (3..$#{@{$args}}) {
      #&DEBUG($self,"Set: add index($index)");
      $ignore{$$args[$index]} = 1;
    }
    foreach my $child (@children) {
      next if exists($ignore{$self->{TREE}->{$child."-tag"}});
      #&DEBUG($self,"Set: add child ($child)");
      #&DEBUG($self,"Set: root tag (",$self->{TREE}->{$child."-tag"},")");
      $self->{TREE}->{$child."-att-xmlns"} = $$args[2];
      $self->{TREE}->{$child."-att-__netjabber__:ignore"} = "__netjabber__";
      $self->{TREE}->{root} = $child;
      #&DEBUG($self,"Set: add call (\$self->Add$$args[1](\$self->{TREE});)");
      eval "\$self->Add$$args[1](\$self->{TREE});";
    }
    #&DEBUG($self,"Set: add end");
    return;
  }
  if ($type eq "master") {
    eval "\$self->MasterSet(\@_);" if ($key eq "");
    eval "\$self->MasterSetAll(\@_);" if ($key eq "all");
    return;
  }
  if ($type eq "special") {
    if ($arg0 eq "") {
      $self->{DATA}->{__netjabbertime__} = time
	unless exists($self->{DATA}->{__netjabbertime__});
      my $value;
      $value = (&POSIX::uname())[0] if ($key eq "os");
      if ($key eq "utc") {
	$value = &Net::Jabber::GetTimeStamp("utc",$self->{DATA}->{__netjabbertime__},"stamp");
      }
      $value = uc(&tz_name(&tz_local_offset()))
	if (($key eq "tz") && ($TIMEZONE == 1));
      $value = &Net::Jabber::GetTimeStamp("local",$self->{DATA}->{__netjabbertime__}) if ($key eq "display");

      $value = "Net::Jabber v$Net::Jabber::VERSION" if ($key eq "version");

      $self->{DATA}->{$key} = $value;
    } else {
      my $value = $arg0;
      $value = $arg0." - [Net::Jabber v$Net::Jabber::VERSION]"
	if (($key eq "version") && ($PARSING == 0));
      $self->{DATA}->{$key} = $value;
    }
    return;
  }
}


##############################################################################
#
# Add - generic function to handle adding x children into the fray.
#
##############################################################################
sub Add {
  my $self = shift;
  my $args = shift;
  my $funcs = shift;

  my $tag = $$args[3];
  $tag = shift if ($tag eq "");

  #&DEBUG($self,"Add: tag($tag)");

  my $xTag;
  #&DEBUG($self,"Add: call(\$xTag = \$self->Add$$args[0](\{'root'=>1,'1-tag'=>\$tag});)");

  eval "\$xTag = \$self->Add$$args[0](\{'root'=>1,'1-tag'=>\$tag\});";
  $xTag->SetXMLNS($$args[1]);
  #&DEBUG($self,"Add: call(\$xTag->Set$$args[2](\@_);)");
  eval "\$xTag->Set$$args[2](\@_);";
  return $xTag;
}


##############################################################################
#
# ParseXMLNS - anything that uses the namespace method must frist kow what the
#              xmlns of this thing is... So here's a function to do just that.
#
##############################################################################
sub ParseXMLNS {
  my $self = shift;

  $self->SetXMLNS($self->{TREE}->{$self->{TREE}->{root}."-att-xmlns"})
    if exists($self->{TREE}->{$self->{TREE}->{root}."-att-xmlns"});
}


##############################################################################
#
# ParseTree - since we are not storing the huge XML Tree anymore, we need
#             to parse the tree and build the hash.
#
##############################################################################
sub ParseTree {
  $PARSING++;
  my $self = shift;

  #print "ParseTree: self($self)\n";

  #print "ParseTree: tree\n";
  #&Net::Jabber::printData("  \$tree",$self->{TREE});

  my $root = $self->{TREE}->{'root'};

  #print "ParseTree: start root($root)\n";
  #print "ParseTree: funcs(",join(",",@_),")\n";

  foreach my $function (@_) {
    my $lcfunc = $self->Get($function);

    #print "ParseTree: start eval func($function)\n";

    my $type = $self->Hash($function);
    #print "ParseTree: function($function) type($type)\n";
    #print "ParseTree: function($function) tag($lcfunc)\n";

    if ($type eq "att") {
      eval "\$self->Set$function(\$self->{TREE}->{'${root}-att-$lcfunc'}) if exists(\$self->{TREE}->{'${root}-att-$lcfunc'});";
      next;
    }

    if ($type eq "data") {
      eval "\$self->Set$function(\$self->{TREE}->{'${root}-data'}) if exists(\$self->{TREE}->{'${root}-data'});";
      next;
    }

    if ($type eq "child-data") {
      my @children;
      @children = split(",",$self->{TREE}->{"$root-child"})
	if exists($self->{TREE}->{"$root-child"});
      @children = grep { $self->{TREE}->{"$_-tag"} eq $lcfunc } @children;
      foreach my $childid (@children) {
	eval "\$self->Set$function(\$self->{TREE}->{'${childid}-data'}) if exists(\$self->{TREE}->{'${childid}-data'});";
	eval "\$self->Set$function() unless exists(\$self->{TREE}->{'${childid}-data'});";
      }
      next;
    }

    if ($type eq "child-flag") {
      my @children = split(",",$self->{TREE}->{"$root-child"});
      @children = grep { $self->{TREE}->{"$_-tag"} eq $lcfunc } @children;
      foreach my $childid (@children) {
	eval "\$self->Set$function();";
      }
      next;
    }

    if ($type eq "child-add") {
      $lcfunc = $self->Add($function);
      my @children;
      @children = split(",",$self->{TREE}->{"$root-child"})
	if exists($self->{TREE}->{"$root-child"});
      @children = grep { $self->{TREE}->{"$_-tag"} eq $lcfunc } @children
	unless ($lcfunc eq "");
      eval "\$self->Set$function(\@children);";
      next;
    }

    if ($type =~ /^att-(.+)-(.+)$/) {
      my $child = $1;
      my $att = $2;

      my @children;
      @children = split(",",$self->{TREE}->{"$root-child"})
	if exists($self->{TREE}->{"$root-child"});
      @children = grep { $self->{TREE}->{"$_-tag"} eq $child } @children;
      foreach my $childid (@children) {
	eval "\$self->Set$function(\$self->{TREE}->{'${childid}-att-${att}'}) if exists(\$self->{TREE}->{'${childid}-att-${att}'});";
      }
      next;
    }

    #print "ParseTree: stop eval func($function)\n";
  }

  my $count = 0;
  my @xTrees = &XML::Stream::GetXMLData("tree array",$self->{TREE},"*","xmlns","");

  #print "xtrees:\n";
  #&Net::Jabber::printData("  \$xTrees",\@xTrees);
  #print "ParseTree: root($root) ref(",ref($self),")\n";

  if ($#xTrees > -1) {
    if ((ref($self) eq "Net::Jabber::IQ") ||
	(ref($self) eq "Net::Jabber::Query")) {

      #print "do the query:\n";
      #&Net::Jabber::printData("  \$xTrees",\@xTrees);
      $self->{TREE}->{'root'} = shift(@xTrees);
      $self->AddQuery($self->{TREE});
    }

    if ((ref($self) eq "Net::Jabber::XDB") ||
	(ref($self) eq "Net::Jabber::Data")) {

      #print "do the data:\n";
      #&Net::Jabber::printData("  \$xTrees",\@xTrees);
      $self->{TREE}->{'root'} = shift(@xTrees);
      $self->AddData($self->{TREE});
    }

    #print "now for x:\n";
    #&Net::Jabber::printData("  \$xTrees",\@xTrees);

    foreach my $xTree (@xTrees) {
      $self->{TREE}->{'root'} = $xTree;
      if (ref($self) eq "Net::Jabber::Query") {
	$self->AddQuery($self->{TREE});
      } elsif (ref($self) eq "Net::Jabber::Data") {
	$self->AddData($self->{TREE});
      } else {
	$self->AddX($self->{TREE});
      }
    }
  }

  #print "tree:\n";
  #$self->debug();
  $PARSING--;
}


sub GetXML {
  my $self = shift;
  my(@funcs) = @_;

  #&DEBUG($self,"\n",&Net::Jabber::sprintData("  \$self->{DATA}->",$self->{DATA})) if &DEBUG($self,"GetXML: tree");

  my %funcs;
  foreach my $func (@funcs) {
    if (exists($self->{DATA}->{$self->Get($func)})) {
      if (exists($funcs{$self->Hash($func)})) {
	$funcs{$self->Hash($func)} .= ",$func";
      } else {
	$funcs{$self->Hash($func)} = "$func";
      }
    }	
  }

  my $string = "<".$self->{TAG};

  if (exists($funcs{att})) {
    foreach my $func (split(",",$funcs{att})) {
      if (exists($self->{DATA}->{$self->Get($func)})) {

	my $value = eval "\$self->Get$func();";
	next if ($value =~ /^__netjabber__/);
	next if ($value eq "");
	$value = &XML::Stream::EscapeXML($value);
	$string .= " ".$self->Get($func)."='$value'";
      }
    }
  }

  if (exists($funcs{'data'}) ||
      exists($funcs{'child-data'}) ||
      exists($self->{CHILDREN}->{query}) ||
      exists($self->{CHILDREN}->{data}) ||
      exists($self->{CHILDREN}->{x}) ||
      (exists($self->{RAWXWML}) && ($#{$self->{RAWXML}} > 0))) {

    $string .= ">";

    if (exists($funcs{'data'})) {
      foreach my $func (split(",",$funcs{'data'})) {
	$string .= &XML::Stream::EscapeXML(eval "\$self->Get$func();");
      }
    }

    if (exists($funcs{'child-data'})) {
      foreach my $func (split(",",$funcs{'child-data'})) {
	my $lcfunc = $self->Get($func);
	my $addit = eval "\$self->Defined$func();";
	$addit = 0 unless defined($addit);
	my $valType = eval "\$self->ValType$func();";
	
	if (($valType) eq "array") {
	  my @value = eval "\$self->Get$func();";
	  foreach my $item (@value) {
	    $string .= "<$lcfunc>$item</$lcfunc>";
	  }
	} else {
	  my $value = eval "\$self->Get$func();";
	  $value = &XML::Stream::EscapeXML($value);
	  $value = "" unless defined($value);
	  my $test = "att-$lcfunc-";
	  my @attFuncs = grep { /^$test/; } keys(%funcs);

	  if (($addit == 1) || ($#attFuncs > -1)) {

	    $string .= "<$lcfunc" if ($addit == 1);

	    foreach my $att (@attFuncs) {
	      my $attFunc = $funcs{$att};
	      ($att) = ($att =~ /^$test(.*)$/);

	      my $pass = eval "\$self->Defined$attFunc();";
	      $pass = 0 unless defined($pass);
	      my $attValue = eval "\$self->Get$attFunc();";
	      $attValue = "" unless defined($attValue);
	      $pass = 0 if (($pass == 1) &&
			    (($attValue eq "") ||
			     ($attValue =~ /^__netjabber__/)));

	      if ($pass == 1) {
		$string .= "<$lcfunc" if ($addit == 0);
		$addit = 1;
		$attValue = &XML::Stream::EscapeXML($attValue);
		$string .= " $att='$attValue'";
	      }
	    }
	    if ($addit == 1) {
	      if ($value eq "") {
		$string .= "/>";
	      } else {
		$string .= ">".$value."</$lcfunc>";
	      }
	    }
	  }
	}
      }
    }

    if (exists($self->{CHILDREN}->{query})) {
      foreach my $query (@{$self->{CHILDREN}->{query}}) {
	$string .= $query->GetXML();
      }
    }
    if (exists($self->{CHILDREN}->{data})) {
      foreach my $query (@{$self->{CHILDREN}->{data}}) {
	$string .= $query->GetXML();
      }
    }
    if (exists($self->{CHILDREN}->{x})) {
      foreach my $x (@{$self->{CHILDREN}->{x}}) {
	$string .= $x->GetXML();
      }
    }

    $string .= join("",@{$self->{RAWXML}})
      if (exists($self->{RAWXWML}) && ($#{$self->{RAWXML}} > 0));

    $string .= "</".$self->{TAG}.">";
  } else {
    $string .= "/>";
  }

  return $string;
}


$CALLBACKS{Get} = sub{ return &Net::Jabber::Get(@_); };
$CALLBACKS{Set} = sub{ return &Net::Jabber::Set(@_); };
$CALLBACKS{Add} = sub{ return &Net::Jabber::Add(@_); };
$CALLBACKS{Defined} = sub{ return &Net::Jabber::Defined(@_); };


##############################################################################
#
# AutoLoad - This function is a central location for handling all of the
#            AUTOLOADS for all of the sub modules.
#
##############################################################################
sub AutoLoad {
  my $self = shift;
  my $AutoLoad = shift;
  return if ($AutoLoad =~ /::DESTROY$/);
  my ($package) = ($AutoLoad =~ /^(.*)::/);
  $AutoLoad =~ s/^.*:://;
#  &DEBUG($self,"AutoLoad: tag($self->{TAG}) package($package) function($AutoLoad) args(",join(",",@_),")");
  my ($type,$value) = ($AutoLoad =~ /^(Add|Get|Set|Defined|ValType)(.*)$/);
  $type = "" unless defined($type);
  $value = "" unless defined($value);

  my $arg0 = "";
  my $arg1 = "";
  $arg0 = $_[0] if ($#_ >= 0);
  $arg1 = $_[1] if ($#_ >= 1);

  return $self->{TAG} if ($AutoLoad eq "GetTag");

  my %FUNCTIONS;
  eval "\%FUNCTIONS = \%".$package."::FUNCTIONS";

  return $FUNCTIONS{$arg0}->{Hash} if (($AutoLoad eq "Hash") &&
				       exists($FUNCTIONS{$arg0}) &&
				       exists($FUNCTIONS{$arg0}->{Hash}));
  return $FUNCTIONS{$arg0}->{Get} if (($AutoLoad eq "Get") &&
				      exists($FUNCTIONS{$arg0}) &&
				      exists($FUNCTIONS{$arg0}->{Get}));
  return $FUNCTIONS{$arg0}->{Add}->[3] if (($AutoLoad eq "Add") &&
					   exists($FUNCTIONS{$arg0}) &&
					   exists($FUNCTIONS{$arg0}->{Add}));

  my @funcs = grep { exists($FUNCTIONS{$_}->{Hash}) } keys(%FUNCTIONS);

  return &{$CALLBACKS{$type}}($self,$FUNCTIONS{$value}->{$type},\@funcs,@_)
    if (exists($FUNCTIONS{$value}) &&
	exists($FUNCTIONS{$value}->{$type}));

  return $FUNCTIONS{$value}->{Set}->[0]
    if (exists($FUNCTIONS{$value}) && ($type eq "ValType"));

  if (($package eq "Net::Jabber::X") ||
      ($package eq "Net::Jabber::Query") ||
      ($package eq "Net::Jabber::Data")) {
    my $xmlns = $self->GetXMLNS();
    #&DEBUG($self,"xmlns(",$xmlns,")");
    #&DEBUG($self,"\%FUNCTIONS = \%{\$".$package."::NAMESPACES{\'".$xmlns."\'}}");
    if (defined($xmlns)) {
      eval "\%FUNCTIONS = \%{\$".$package."::NAMESPACES{\'".$xmlns."\'}}";

      push(@funcs, grep { exists($FUNCTIONS{$_}->{Hash}) } keys(%FUNCTIONS));
      return &{$CALLBACKS{$type}}($self,$FUNCTIONS{$value}->{$type},\@funcs,@_)
	if (exists($FUNCTIONS{$value}) &&
	    exists($FUNCTIONS{$value}->{$type}));

      return $FUNCTIONS{$value}->{Set}->[0]
	if (exists($FUNCTIONS{$value}) && ($type eq "ValType"));
    }
  }

  return $FUNCTIONS{$arg0}->{Hash}
    if (exists($FUNCTIONS{$arg0}->{Hash}) && ($AutoLoad eq "Hash"));
  return $FUNCTIONS{$arg0}->{Get}
    if (exists($FUNCTIONS{$arg0}->{Get}) && ($AutoLoad eq "Get"));
  return $FUNCTIONS{$arg0}->{Add}->[3]
    if (exists($FUNCTIONS{$arg0}->{Add}) && ($AutoLoad eq "Add"));

  #&DEBUG($self,"funcs(",join(",",@funcs),")");

  if ($AutoLoad eq "MasterSet") {
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }
    foreach my $func (@funcs) {
      my $lcfunc = lc($func);
      if (exists($args{$lcfunc})) {
	#&DEBUG($self,"MasterSet: call(\$self->Set${func}(\$_[1]);)");
	eval "\$self->Set${func}(\$args{\$lcfunc});";
      }
    }
    return;
  }

  if ($AutoLoad eq "MasterSetAll") {
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }
    foreach my $func (@funcs) {
      next if ($func eq "XMLNS");
      my $lcfunc = lc($func);
      eval "\$self->Set${func}(\$args{\$lcfunc});";
    }
    return;
  }

  return &Net::Jabber::ParseXMLNS($self) if ($AutoLoad eq "ParseXMLNS");
  return &Net::Jabber::ParseTree($self,@funcs) if ($AutoLoad eq "ParseTree");
  return &Net::Jabber::GetXML($self,@funcs) if ($AutoLoad eq "GetXML");
  return &Net::Jabber::InsertRawXML($self,@_) if ($AutoLoad eq "InsertRawXML");
  return &Net::Jabber::ClearRawXML($self) if ($AutoLoad eq "ClearRawXML");

  if (($AutoLoad eq "NewX") ||
      ($AutoLoad eq "NewQuery") ||
      ($AutoLoad eq "NewData") ||
      ($AutoLoad eq "AddX") ||
      ($AutoLoad eq "AddQuery") ||
      ($AutoLoad eq "AddData") ||
      ($AutoLoad eq "RemoveX") ||
      ($AutoLoad eq "RemoveQuery") ||
      ($AutoLoad eq "RemoveData")
     ) {

    my $tag;
    if ($AutoLoad =~ /^New(.*)$/) {
      my $xmlns = $arg0;
      my $obj = $1;

      eval "\%FUNCTIONS = \%{\$Net::Jabber::".$obj."::NAMESPACES{\'".$xmlns."\'}}";
      $tag = $FUNCTIONS{"__netjabber__"}->{Tag}
	if exists($FUNCTIONS{"__netjabber__"}->{Tag});
    }

    return eval("return &Net::Jabber::${AutoLoad}(\$self,\@_,\$tag);");
  }
  return &Net::Jabber::debug($self) if ($AutoLoad eq "debug");

  &Net::Jabber::MissingFunction($self,$AutoLoad);
}


##############################################################################
#
# NewX - calls AddX to create a new Net::Jabber::X object, sets the xmlns and
#        returns a pointer to the new object.
#
##############################################################################
sub NewX {
  my $self = shift;
  my ($xmlns,$tag) = @_;
  $tag = "x" unless defined($tag);
  return $self->AddX({'root'=>1,
		      '1-tag'=>$tag,
		      '1-att-xmlns'=>$xmlns}
		    );
}


##############################################################################
#
# AddX - creates a new Net::Jabber::X object, pushes it on the list, and
#        returns a pointer to the new object.  This is a private helper
#        function.
#
##############################################################################
sub AddX {
  my $self = shift;
  my $xTag = new Net::Jabber::X(shift);
  push(@{$self->{CHILDREN}->{x}},$xTag);
  return $xTag;
}


##############################################################################
#
# RemoveX - removes all xtags that have the specified namespace.
#
##############################################################################
sub RemoveX {
  my $self = shift;
  my ($xmlns) = @_;

  foreach my $index (reverse(0..$#{$self->{CHILDREN}->{x}})) {
    splice(@{$self->{CHILDREN}->{x}},$index,1)
      if (($xmlns eq "") ||
	  ($self->{CHILDREN}->{x}->[$index]->GetXMLNS() eq $xmlns));
  }
}


##############################################################################
#
# NewQuery - calls SetQuery to create a new Net::Jabber::Query object, sets
#            the xmlns and returns a pointer to the new object.
#
##############################################################################
sub NewQuery {
  my $self = shift;
  my ($xmlns,$tag) = @_;
  $tag = "query" unless defined($tag);
  $self->RemoveQuery();
  return $self->AddQuery({'root'=>1,
			  '1-tag'=>$tag,
			  '1-att-xmlns'=>$xmlns}
			);
}


##############################################################################
#
# AddQuery - creates a new Net::Jabber::Query object, sets the internal
#            pointer to it, and returns a pointer to the new object.  This
#            is a private helper function.
#
##############################################################################
sub AddQuery {
  my $self = shift;
  my $queryTag = new Net::Jabber::Query(shift);
  push(@{$self->{CHILDREN}->{query}},$queryTag);
  return $queryTag;
}


##############################################################################
#
# RemoveQuery - removes all querytags that have the specified namespace.
#
##############################################################################
sub RemoveQuery {
  my $self = shift;
  my ($xmlns) = @_;

  foreach my $index (reverse(0..$#{$self->{CHILDREN}->{query}})) {
    splice(@{$self->{CHILDREN}->{query}},$index,1)
      if (($xmlns eq "") ||
	  ($self->{CHILDREN}->{query}->[$index]->GetXMLNS() eq $xmlns));
  }
}


##############################################################################
#
# NewData - calls SetData to create a new Net::Jabber::Data object, sets
#            the xmlns and returns a pointer to the new object.
#
##############################################################################
sub NewData {
  my $self = shift;
  my ($xmlns,$tag) = @_;
  $tag = "data" unless defined($tag);
  $self->RemoveData();
  return $self->AddData({'root'=>1,
			 '1-tag'=>$tag,
			 '1-att-xmlns'=>$xmlns}
			);
}


##############################################################################
#
# AddData - creates a new Net::Jabber::Data object, sets the internal
#            pointer to it, and returns a pointer to the new object.  This
#            is a private helper function.
#
##############################################################################
sub AddData {
  my $self = shift;
  my $dataTag = new Net::Jabber::Data(shift);
  push(@{$self->{CHILDREN}->{data}},$dataTag);
  return $dataTag;
}


##############################################################################
#
# RemoveData - removes all datatags that have the specified namespace.
#
##############################################################################
sub RemoveData {
  my $self = shift;
  my ($xmlns) = @_;

  foreach my $index (reverse(0..$#{$self->{CHILDREN}->{data}})) {
    splice(@{$self->{CHILDREN}->{data}},$index,1)
      if (($xmlns eq "") ||
	  ($self->{CHILDREN}->{data}->[$index]->GetXMLNS() eq $xmlns));
  }
}


##############################################################################
#
# InsertRawXML - puts the specified string onto the list for raw XML to be
#                included in the packet.
#
##############################################################################
sub InsertRawXML {
  my $self = shift;
  my(@rawxml) = @_;
  if (!exists($self->{RAWXML})) {
    $self->{RAWXML} = [];
  }
  push(@{$self->{RAWXML}},@rawxml);
}


##############################################################################
#
# ClearRawXML - removes all raw XML from the packet.
#
##############################################################################
sub ClearRawXML {
  my $self = shift;
  $self->{RAWXML} = [];
}


##############################################################################
#
# printData - debugging function to print out any data structure in an
#             organized manner.  Very useful for debugging XML::Parser::Tree
#             objects.  This is a private function that will only exist in
#             in the development version.
#
##############################################################################
sub printData {
  print &sprintData(@_);
}


##############################################################################
#
# sprintData - debugging function to build a string out of any data structure
#              in an organized manner.  Very useful for debugging
#              XML::Parser::Tree objects and perl hashes of hashes.
#
#              This is a private function.
#
##############################################################################
sub sprintData {
  my ($preString,$data) = @_;

  my $outString = "";

  if (ref($data) eq "HASH") {
    my $key;
    foreach $key (sort { $a cmp $b } keys(%{$data})) {
      if (ref($$data{$key}) eq "") {
	$outString .= $preString."{'$key'} = \"$$data{$key}\";\n";
      } else {
	if (ref($$data{$key}) =~ /Net::Jabber/) {
	  $outString .= $preString."{'$key'} = ".ref($$data{$key}).";\n";
	} else {
	  $outString .= $preString."{'$key'};\n";
	  $outString .= &sprintData($preString."{'$key'}->",$$data{$key});
	}
      }
    }
  } else {
    if (ref($data) eq "ARRAY") {
      my $index;
      foreach $index (0..$#{$data}) {
	if (ref($$data[$index]) eq "") {
	  $outString .= $preString."[$index] = \"$$data[$index]\";\n";
	} else {
	  if (ref($$data[$index]) =~ /Net::Jabber/) {
	    $outString .= $preString."[$index] = ".ref($$data[$index]).";\n";
	  } else {
	    $outString .= $preString."[$index];\n";
	    $outString .= &sprintData($preString."[$index]->",$$data[$index]);
	  }
	}
      }
    } else {
      if (ref($data) eq "REF") {
	$outString .= &sprintData($preString."->",$$data);
      } else {
	if (ref($data) eq "") {
	  $outString .= $preString." = \"$data\";\n";
	} else {
 	  $outString .= $preString." = ".ref($data).";\n";
	}
      }
    }
  }

  return $outString;
}


##############################################################################
#
# GetTimeStamp - generic funcion for getting a timestamp.
#
##############################################################################
sub GetTimeStamp {
  my($type,$time,$length) = @_;

  return "" if (($type ne "local") && ($type ne "utc") && !($type =~ /^(local|utc)delay(local|utc|time)$/));

  $length = "long" unless defined($length);

  my ($sec,$min,$hour,$mday,$mon,$year,$wday);
  if ($type =~ /utcdelay/) {
    ($year,$mon,$mday,$hour,$min,$sec) = ($time =~ /^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)\:(\d\d)\:(\d\d)$/);
    $mon--;
    ($type) = ($type =~ /^utcdelay(.*)$/);
    $time = timegm($sec,$min,$hour,$mday,$mon,$year);
  }
  if ($type =~ /localdelay/) {
    ($year,$mon,$mday,$hour,$min,$sec) = ($time =~ /^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)\:(\d\d)\:(\d\d)$/);
    $mon--;
    ($type) = ($type =~ /^localdelay(.*)$/);
    $time = timelocal($sec,$min,$hour,$mday,$mon,$year);
  }

  return $time if ($type eq "time");
  ($sec,$min,$hour,$mday,$mon,$year,$wday) = localtime(((defined($time) && ($time ne "")) ? $time : time)) if ($type eq "local");
  ($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime(((defined($time) && ($time ne "")) ? $time : time)) if ($type eq "utc");

  return sprintf("%d%02d%02dT%02d:%02d:%02d",($year + 1900),($mon+1),$mday,$hour,$min,$sec) if ($length eq "stamp");

  $wday = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[$wday];

  my $month = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')[$mon];
  $mon++;

  return sprintf("%3s %3s %02d, %d %02d:%02d:%02d",$wday,$month,$mday,($year + 1900),$hour,$min,$sec) if ($length eq "long");
  return sprintf("%3s %d/%02d/%02d %02d:%02d",$wday,($year + 1900),$mon,$mday,$hour,$min) if ($length eq "normal");
  return sprintf("%02d:%02d:%02d",$hour,$min,$sec) if ($length eq "short");
  return sprintf("%02d:%02d",$hour,$min) if ($length eq "shortest");
}


1;
