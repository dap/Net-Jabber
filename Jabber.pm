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


  NOTE: The parser that XML::Stream::Parser provides, as are most Perl
  parsers, is synchronous.  If you are in the middle of parsing a
  packet and call a user defined callback, the Parser is blocked until
  your callback finishes.  This means you cannot be operating on a
  packet, send out another packet and wait for a response to that packet.
  It will never get to you.  Threading might solve this, but as we all
  know threading in Perl is not quite up to par yet.  This issue will be
  revisted in the future.


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

  GetTag() - return the root tag name of the packet.

  GetTree() - return the XML::Stream::Node object that contains the
              data. See XML::Stream::Node for methods you can call
              on this object.

=head2 Creation functions

  NewX(namespace)     - creates a new Net::Jabber::X object with the
  NewX(namespace,tag)   specified namespace and root tag of <x/>.
                        Optionally you may specify another root tag
                        if <x/> is not desired.

                        $xObj = $obj->NewX("my:namespace");
                        $xObj = $obj->NewX("my:namespace","foo");
                          ie. <foo xmlns='my:namespace'...></foo>

  InsertRawXML(string) - puts the specified string raw into the XML
                         packet that you call this on.

                         $message->InsertRawXML("<foo></foo>")
                           <message...>...<foo></foo></message>

                         $x = $message->NewX(..);
                         $x->InsertRawXML("test");

                         $query = $iq->GetQuery(..);
                         $query->InsertRawXML("test");

  ClearRawXML() - removes the raw XML from the packet.

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
use XML::Stream 1.16 qw( Node );
use Time::Local;
use Carp;
use Digest::SHA1;
use POSIX;
use vars qw($VERSION $DEBUG %CALLBACKS $TIMEZONE $PARSING);

$CALLBACKS{XPathGet}     = sub{ return &Net::Jabber::XPathGet(@_); };
$CALLBACKS{XPathSet}     = sub{ return &Net::Jabber::XPathSet(@_); };
$CALLBACKS{XPathDefined} = sub{ return &Net::Jabber::XPathDefined(@_); };
$CALLBACKS{XPathAdd}     = sub{ return &Net::Jabber::XPathAdd(@_); };
$CALLBACKS{XPathRemove}  = sub{ return &Net::Jabber::XPathRemove(@_); };


if (eval "require Time::Timezone")
{
    $TIMEZONE = 1;
    Time::Timezone->import(qw(tz_local_offset tz_name));
}
else
{
    $TIMEZONE = 0;
}

$VERSION = "1.27";

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

$DEBUG = new Net::Jabber::Debug(usedefault=>1,
                header=>"NJ::Main");

require Exporter;
my @ISA = qw(Exporter);
my @EXPORT_OK = qw(Client Component Server);

sub import 
{
    my $class = shift;

    my $pass = 0;
    foreach my $module (@_)
    {
        eval "use Net::Jabber::$module;";
        croak($@) if ($@);
        eval "(\$Net::Jabber::${module}::VERSION < \$VERSION) && croak(\"Net::Jabber::$module \$VERSION required--this is only version \$Net::Jabber::${module}::VERSION\");";
        croak($@) if ($@);
        $pass = 1;
    }
    croak("Failed to load any schema for Net::Jabber from the use line.\n  ie. \"use Net::Jabber qw( Client );\"\n") if ($pass == 0);

    #---------------------------------------------------------------------------
    # Stupid "feature"... this has to be loaded last... or it can't see the
    # other modules that were loaded.  So let's load it at the end of the
    # import block.
    #---------------------------------------------------------------------------
    eval "use Net::Jabber::Protocol;";
    ($Net::Jabber::Protocol::VERSION < $VERSION) &&
        croak("Net::Jabber::Protocol $VERSION required--this is only version $Net::Jabber::Protocol::VERSION");
}


##############################################################################
#
# DEBUG - helper function for printing debug messages using Net::Jabber::Debug
#
##############################################################################
sub DEBUG
{
    my $self = shift;
    return $DEBUG->Log99($self->{DEBUGHEADER},": ",@_);
}


##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for debugging
#
##############################################################################
sub debug
{
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
sub MissingFunction
{
    my ($parent,$function) = @_;
    croak("Undefined function $function in package ".ref($parent));
}


##############################################################################
#
# XPathGet - returns the value stored in the node 
#
##############################################################################
sub XPathGet
{
    my $self = shift;
    my $type = shift;
    my $xpath = shift;
    my $childtype = shift;
    my ($arg0) = shift;
    
    #print "XPathGet: self($self) type($type) xpath($xpath) childtype($childtype)\n";
    #$self->{TREE}->debug();

    my $subType = "";
    if (ref($type) eq "ARRAY")
    {
        if ($type->[0] eq "special")
        {
            $subType = $type->[1];
            $type = "scalar";
        }
    }
    
    my @results;

    if ($type eq "flag")
    {
        my @nodes = $self->{TREE}->XPath($xpath);
        return $#nodes > -1;
    }
    
    if ($type eq "node")
    { 
        my $childloc = $childtype;
        $childloc = $childtype->[0] if (ref($childtype) eq "ARRAY");

        #print "XPathGet: childloc($childloc) xmlns($arg0)\n"; 

        foreach my $child (@{$self->{CHILDREN}->{lc($childloc)}})
        {
            push(@results,$child)
                 if (!defined($arg0) ||
                     ($arg0 eq "") || 
                     ($child->GetTree(1)->get_attrib("xmlns") eq $arg0));
        }
        
        return @results if (wantarray);
        return $results[0];
    }

    if ($type eq "children")
    {
        my ($childtype,$xmlns) = @{$childtype};

        #print "XPathGet: children: childtype($childtype) xmlns($xmlns)\n";

        if (exists($self->{CHILDREN}->{lc($childtype)}))
        {
            foreach my $child (@{$self->{CHILDREN}->{lc($childtype)}})
            {
                push(@results, $child)
                    if (!defined($xmlns) ||
                        ($xmlns eq "") ||
                        ($child->GetTree(1)->get_attrib("xmlns") eq $xmlns));
            }
        }
        foreach my $node ($self->{TREE}->XPath($xpath))
        {
            $node->put_attrib(xmlns=>$xmlns);
            my $result;
            #print "\$result = \$self->Add$childtype(\$node);\n";
            eval "\$result = \$self->Add$childtype(\$node);";
            $self->{TREE}->remove_child($node);
            push(@results,$result);
        }

        #print "XPathGet: children: ",join(",",@results),"\n";
        return @results if (wantarray);
        return $results[0];
     }
    
    @results = $self->{TREE}->XPath($xpath);

    if (($type eq "scalar") || ($type eq "timestamp"))
    {
        return "" if ($#results == -1);
        return $results[0];
    }
    if ($type eq "jid")
    {
        return if ($#results == -1);
        return new Net::Jabber::JID($results[0])
            if (defined($arg0) && ($arg0 eq "jid"));
        return $results[0];
    }
    if ($type eq "array")
    {
        if (wantarray)
        {
            return @results;
        }
        else
        {
            return $results[0];
        }
    }
}


##############################################################################
#
# XPathSet - makes the XML tree such that the value was set.
#
##############################################################################
sub XPathSet
{
    my $self = shift;
    my $type = shift;
    my $xpath = shift;
    my $childtype = shift;

    my $subType = "";
    if (ref($type) eq "ARRAY")
    {
        if ($type->[0] eq "special")
        {
            $subType = $type->[1];
            $type = "scalar";
        }
        elsif ($type->[0] eq "master")
        {
            $subType = $type->[1];
            $type = "master";
        }
    }
    
    #print "XPathSet: self($self) type($type) xpath($xpath) childtype($childtype)\n";

    my $node = $self->{TREE};

    #print "XPathSet: node($node)\n";

    if ($type eq "master")
    {
        #print "XPathSet: master: funcs(",join(",",@{$childtype}),")\n";
        my %args;
        while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }
        #print "XPathSet: args(",%args,")\n";
        foreach my $func (sort {$a cmp $b} @{$childtype})
        {
            #print "XPathSet: func($func)\n";
            if (exists($args{lc($func)}))
            {
                #print "\$self->Set$func(\$args{lc(\$func)});\n";
                eval "\$self->Set$func(\$args{lc(\$func)});";
            }
            elsif ($subType eq "all")
            {
                eval "\$self->Set$func();";
            }
        }
        return;
    }

    my $value = shift;

    if ($subType ne "")
    {
        $self->{DATA}->{__netjabbertime__} = time
            unless exists($self->{DATA}->{__netjabbertime__});
        if ($subType eq "time-display")
        {
            $value = &Net::Jabber::GetTimeStamp("local",$self->{DATA}->{__netjabbertime__})
                unless defined($value);
        }
        if ($subType eq "time-tz") 
        {
            if ($TIMEZONE == 1)
            {
                $value = uc(&tz_name(&tz_local_offset()))
                    unless defined($value);
            }
        }
        if ($subType eq "time-utc")
        {
            $value = &Net::Jabber::GetTimeStamp("utc",$self->{DATA}->{__netjabbertime__},"stamp")
                unless defined($value);
        }

        if ($subType eq "version-os")
        {
            $value = (&POSIX::uname())[0];
        }
        if ($subType eq "version-version")
        {
            if (defined($value))
            {
                $value .= " - [ Net::Jabber v$Net::Jabber::VERSION ]";
            }
            else
            {
                $value = "Net::Jabber v$Net::Jabber::VERSION";
            }
        }
        
    }
        
    if ($type eq "timestamp") {
        $value = "" unless defined($value);
        if ($value eq "") {
            $value = &Net::Jabber::GetTimeStamp("utc","","stamp");
        }
    }
    
    #print "XPathSet: value($value)\n";

    my @values;
    push(@values,$value);
    if ($type eq "array")
    {
        if (ref($value) eq "ARRAY")
        {
            @values = @{$value};
        }
    }

    foreach my $val (@values)
    {
        next unless defined($val) || ($type eq "flag");

        if (ref($val) eq "Net::Jabber::JID")
        {
            $val = $val->GetJID("full");
        }

        my $path = $xpath;
        #print "XPathSet: val($val) path($path)\n";
    
        if (($path !~ /^\/?\@/) && ($path !~ /^\/?text\(\)/))
        {
            #print "XPathSet: Multi-level!!!!\n";
            my ($child) = ($path =~ /^\/?([^\/]+)/);
            $path =~ s/^\/?[^\/]+//;

            if (($type eq "scalar") || ($type eq "jid") || ($type eq "timestamp"))
            {
                my @nodes = $self->{TREE}->XPath("$child");
                if ($#nodes == -1)
                {
                    $node = $self->{TREE}->add_child($child);
                }
                else
                {
                    $node = $nodes[0];
                }
            }

            if ($type eq "array")
            {
                $node = $self->{TREE}->add_child($child);
            }

            if ($type eq "flag")
            {
                $node = $self->{TREE}->add_child($child);
                return;
            }
        }

        my ($piece) = ($path =~ /^\/?([^\/]+)/);
    
        #print "XPathSet: piece($piece)\n";

        if ($piece =~ /^\@(.+)$/)
        {
            $node->put_attrib($1=>$val);
        }
        elsif ($piece eq "text()")
        {
            $node->remove_cdata();
            $node->add_cdata($val);
        }
    }
}


##############################################################################
#
# XPathDefined - returns true if there is data for the requested item, false
#                otherwise.
#
##############################################################################
sub XPathDefined
{
    my $self = shift;
    my $type = shift;
    my $xpath = shift;
    my $childtype = shift;

    #print "XPathDefined: self($self) type($type) xpath($xpath) childtype($childtype)\n";

    my @nodes = $self->{TREE}->XPath($xpath);
    my $defined = ($#nodes > -1);
    
    #print $self->{TREE}->GetXML(),"\n";
    #print "nodes(",join(",",@nodes),")\n";
    #print $#nodes,"\n";

    if (!$defined && ($type eq "children"))
    {
        foreach my $packet (@{$self->{CHILDREN}->{lc($childtype->[0])}})
        {
            if ($packet->GetXMLNS() eq $childtype->[1])
            {
                $defined = 1;
                last;
            }
        }
    }

    #print "defined($defined)\n";

    return $defined;
}


##############################################################################
#
# XPathAdd - returns the value stored in the node 
#
##############################################################################
sub XPathAdd
{
    my $self = shift;
    my $type = shift;
    my $xpath = shift;
    my $childtype = shift;

    my $objType = $childtype->[0];
    my $xmlns = $childtype->[1];
    my $master = $childtype->[2];

    my %opts;
    foreach my $index (3..$#{$childtype})
    {
        next unless defined($childtype->[$index]);
        $opts{$childtype->[$index]} = $index;
    }

    #print "XPathAdd: self($self) type($type) xpath($xpath) childtype($childtype)\n";
    #print "XPathAdd: childtype(",join(",",@{$childtype}),")\n" if (ref($childtype) eq "ARRAY");
    #print "XPathAdd: objType($objType) xmlns($xmlns) master($master)\n";

    my $tag = $xpath;
    if (exists($opts{"__netjabber__:specifyname"})) {
        if (($#_ > -1) && (($#_/2) =~ /^\d+$/))
        {
            $tag = shift;
        }
        else
        {
            $tag = $childtype->[$opts{"__netjabber__:specifyname"}+1];
        }
    }
    
    my $node = new XML::Stream::Node($tag);
    $node->put_attrib(xmlns=>$xmlns);

    my $NJObj;
    eval "\$NJObj = \$self->Add$objType(\$node);";
    eval "\$NJObj->Set$master(\@_);"
        if defined($master);

    $NJObj->SkipXMLNS()
        if exists($opts{"__netjabber__:skip_xmlns"});

    return $NJObj;
}


##############################################################################
#
# XPathRemove - remove the specified thing from the data (I know it's vague.)
#
##############################################################################
sub XPathRemove
{
    my $self = shift;
    my $type = shift;
    my $xpath = shift;
    my $childtype = shift;

    #print "XPathRemove: self($self) type($type) xpath($xpath) childtype($childtype)\n";

    my $nodePath = $xpath;
    $nodePath =~ s/\/?\@\S+$//;
    $nodePath =~ s/\/text\(\)$// if ($type eq "array");

    my @nodes = $self->{TREE}->XPath($nodePath);

    if ($xpath =~ /\@(\S+)/)
    {
        my $attrib = $1;
        foreach my $node (@nodes)
        {
            $node->remove_attrib($1);
        }
        return;
    }
    
    if ($type eq "array")
    {
        foreach my $node (@nodes)
        {
            $self->{TREE}->remove_child($node);
        }
        return;
    }
}


##############################################################################
#
# ParseXMLNS - anything that uses the namespace method must frist kow what the
#              xmlns of this thing is... So here's a function to do just that.
#
##############################################################################
sub ParseXMLNS
{
    my $self = shift;

    #$self->SetXMLNS($self->{TREE}->{$self->{TREE}->{root}."-att-xmlns"})
    #    if exists($self->{TREE}->{$self->{TREE}->{root}."-att-xmlns"});
    $self->SetXMLNS($self->{TREE}->get_attrib("xmlns"))
        if defined($self->{TREE}->get_attrib("xmlns"));
}


##############################################################################
#
# ParseTree - since we are not storing the huge XML Tree anymore, we need
#             to parse the tree and build the hash.
#
##############################################################################
sub ParseTree
{
    $PARSING++;
    my $self = shift;

    #print "ParseTree: self($self)\n";

    #print "ParseTree: tree\n";
    #$self->{TREE}->debug();

    my @xTrees = $self->{TREE}->XPath('*[@xmlns]');

    #print "xtrees:\n";
    #&Net::Jabber::printData("  \$xTrees",\@xTrees);

    if ($#xTrees > -1) {
        if (((ref($self) eq "Net::Jabber::IQ") ||
            (ref($self) eq "Net::Jabber::Query")) &&
            exists($Net::Jabber::Query::NAMESPACES{$xTrees[0]->get_attrib("xmlns")})) {

            #print "do the query:\n";
            #$xTrees[0]->debug();
            my $node = shift(@xTrees);
            $self->AddQuery($node);
            $self->{TREE}->remove_child($node);
        }

        if (((ref($self) eq "Net::Jabber::XDB") ||
            (ref($self) eq "Net::Jabber::Data")) &&
            exists($Net::Jabber::Data::NAMESPACES{$xTrees[0]->get_attrib("xmlns")})) {

            #print "do the data:\n";
            #$xTrees[0]->debug();
            my $node = shift(@xTrees);
            $self->AddData($node);
            $self->{TREE}->remove_child($node);
        }

        #print "now for x:\n";
        #&Net::Jabber::printData("  \$xTrees",\@xTrees);

        foreach my $xTree (@xTrees) {
            #print "xTree:\n";
            #$xTree->debug();
            if ((ref($self) eq "Net::Jabber::Query") &&
                exists($Net::Jabber::Query::NAMESPACES{$xTree->get_attrib("xmlns")})) {
                $self->AddQuery($xTree);
                $self->{TREE}->remove_child($xTree);
            } elsif ((ref($self) eq "Net::Jabber::Data")  &&
                     exists($Net::Jabber::Data::NAMESPACES{$xTree->get_attrib("xmlns")})) {
                $self->AddData($xTree);
                $self->{TREE}->remove_child($xTree);
            } elsif (exists($Net::Jabber::X::NAMESPACES{$xTree->get_attrib("xmlns")})) {
                $self->AddX($xTree);
                $self->{TREE}->remove_child($xTree);
            }
        }
    }

    #print "tree:\n";
    #print "**************************\n";
    #$self->debug();
    #print "**************************\n";
    $PARSING--;
}


##############################################################################
#
# GetXML - Returns a string that represents the packet.
#
##############################################################################
sub GetXML
{
    my $self = shift;
    my $rawXML = "";
    if (exists($self->{RAWXML}))
    {
        foreach my $raw (@{$self->{RAWXML}})
        {
            $rawXML .= $raw;
        }
    }
    return $self->GetTree()->GetXML($rawXML);
}


##############################################################################
#
# GetTree - Returns an XML::Stream::Node that contains the full tree including
#           Query, Data, and X children.
#
##############################################################################
sub GetTree
{
    my $self = shift;
    my $keepXMLNS = shift;
    $keepXMLNS = 0 unless defined($keepXMLNS);

    #print "GetTree: keepXMLNS($keepXMLNS)\n";
    
    my $node = $self->{TREE}->copy();

    $node->remove_attrib("xmlns")
        if (exists($self->{SKIPXMLNS}) && ($keepXMLNS == 0));
    
    if (((ref($self) eq "Net::Jabber::IQ") ||
        (ref($self) eq "Net::Jabber::Query")) &&
        exists($self->{CHILDREN}->{query}))
    {
        foreach my $child (@{$self->{CHILDREN}->{query}})
        {
            my $child_tree = $child->GetTree($keepXMLNS);
            $node->add_child($child_tree);
        }
    }
    
    if (((ref($self) eq "Net::Jabber::XDB") ||
        (ref($self) eq "Net::Jabber::Data")) &&
        exists($self->{CHILDREN}->{data}))
    {
        foreach my $child (@{$self->{CHILDREN}->{data}})
        {
            my $child_tree = $child->GetTree($keepXMLNS);
            $node->add_child($child_tree);
        }
    }
    
    if (exists($self->{CHILDREN}->{x}))
    {
        foreach my $child (@{$self->{CHILDREN}->{x}})
        {
            my $child_tree = $child->GetTree($keepXMLNS);
            $node->add_child($child_tree);
        }
    }

    $node->remove_attrib("xmlns")
        if (defined($node->get_attrib("xmlns")) &&
            ($node->get_attrib("xmlns") =~ /^__netjabber__/) &&
            ($keepXMLNS == 0));

    return $node;
}


##############################################################################
#
# SkipXMLNS - in the GetTree function, cause the xmlns attribute to be
#             removed for a node that has this set.
#
##############################################################################
sub SkipXMLNS
{
    my $self = shift;

    $self->{SKIPXMLNS} = 1;
}


##############################################################################
#
# XPathAutoLoad - This function is a helper function for the main AutoLoad
#                 function to help cut down on repeating code.
#
##############################################################################
sub XPathAutoLoad
{
    my ($self,$package,$value,$type,$setFuncs,$FUNCTIONS) = @_;

    #print "XPathAutoLoad: self($self) package($package) value($value) type($type)\n";
    #print "XPathAutoLoad: setFuncs(",join(",",@{$setFuncs}),")\n";
                
    my $XPathCall = 0;
    my $XPathType = "scalar";
    my $XPathPath = "";
    my $XPathChildType = "";
    if (exists($FUNCTIONS->{$value}->{XPath}))
    {
        $XPathType = $FUNCTIONS->{$value}->{XPath}->{Type}
           if exists($FUNCTIONS->{$value}->{XPath}->{Type});

        $XPathPath = $FUNCTIONS->{$value}->{XPath}->{Path}
            if exists($FUNCTIONS->{$value}->{XPath}->{Path});

        my @calls = ('Get','Set','Defined','Remove');
        @calls = ('Get','Set') if ($XPathType eq "master");
        @calls = @{$FUNCTIONS->{$value}->{XPath}->{Calls}}
            if (exists($FUNCTIONS->{$value}->{XPath}->{Calls}));

        foreach my $call (@calls)
        {
            if ($call eq $type)
            {
                $XPathCall = 1;
                last;
            }
        }

        if (($XPathType eq "master") ||
            ((ref($XPathType) eq "ARRAY") && ($XPathType->[0] eq "master")))
        {
            $XPathChildType = $setFuncs;
        }
        else
        {
            if (exists($FUNCTIONS->{$value}->{XPath}->{Child}))
            {
                $XPathChildType = $FUNCTIONS->{$value}->{XPath}->{Child};
                
                #print "XPathAutoLoad: childtype($XPathChildType)\n";

                if (ref($XPathChildType) eq "ARRAY")
                {
                    my @rest = ();
                    if ($#{$XPathChildType} > 1)
                    {
                        @rest = splice(@{$XPathChildType},2,($#{$XPathChildType}-1));
                    }
                
                    my $addXMLNS = $XPathChildType->[1];
                
                    my %ADDFUNCS;
                    eval "\%ADDFUNCS = \%{\$".$package."::NAMESPACES{\'".$addXMLNS."\'}}";
                    my @calls =
                    grep{
                        exists($ADDFUNCS{$_}->{XPath}->{Type}) &&
                            ($ADDFUNCS{$_}->{XPath}->{Type} eq "master")
                    } keys(%ADDFUNCS);
                    if ($#calls > 0)
                    {
                        print STDERR "Warning: I cannot serve two masters.\n";
                    }
                    push(@{$XPathChildType},$calls[0]);
                    push(@{$XPathChildType},@rest);
                }
            }
        }
    }

    return ($XPathCall,$XPathType,$XPathPath,$XPathChildType);
}


##############################################################################
#
# AutoLoad - This function is a central location for handling all of the
#            AUTOLOADS for all of the sub modules.
#
##############################################################################
sub AutoLoad
{
    my $self = shift;
    my $AutoLoad = shift;
    return if ($AutoLoad =~ /::DESTROY$/);
    my ($package) = ($AutoLoad =~ /^(.*)::/);
    $AutoLoad =~ s/^.*:://;
    my ($type,$value) = ($AutoLoad =~ /^(Add|Get|Set|Remove|Defined)(.*)$/);
    $type = "" unless defined($type);
    $value = "" unless defined($value);

    #print "AutoLoad: tag($self->{TAG}) package($package) function($AutoLoad) args(",join(",",@_),")\n";
    #print "AutoLoad: type($type) value($value)\n";

    #-------------------------------------------------------------------------
    # First pick off some common functions
    #-------------------------------------------------------------------------
    return $self->{TAG} if ($AutoLoad eq "GetTag");
    return &GetTree($self,@_) if ($AutoLoad eq "GetTree");
    return &SkipXMLNS($self) if ($AutoLoad eq "SkipXMLNS");
    return &Net::Jabber::ParseXMLNS($self) if ($AutoLoad eq "ParseXMLNS");
    return &Net::Jabber::ParseTree($self) if ($AutoLoad eq "ParseTree");
    return &Net::Jabber::GetXML($self) if ($AutoLoad eq "GetXML");
    return &Net::Jabber::InsertRawXML($self,@_) if ($AutoLoad eq "InsertRawXML");
    return &Net::Jabber::ClearRawXML($self) if ($AutoLoad eq "ClearRawXML");

    #-------------------------------------------------------------------------
    # Pick off calls for top level tags <message/>, <presence/>, and <iq/>
    #-------------------------------------------------------------------------
    my %FUNCTIONS;
    eval "\%FUNCTIONS = \%".$package."::FUNCTIONS";

    my @setFuncs = grep { exists($FUNCTIONS{$_}->{XPath}) && ($_ ne $value) } keys(%FUNCTIONS);
    my ($XPathCall,@XPathArgs) = &XPathAutoLoad($self,$package,$value,$type,\@setFuncs,\%FUNCTIONS);
    return &{$CALLBACKS{"XPath".$type}}($self,@XPathArgs,@_) if ($XPathCall == 1);
        
    #-------------------------------------------------------------------------
    # Run through calls for sub items Query, X, and Data
    #-------------------------------------------------------------------------
    if (($package eq "Net::Jabber::X") ||
        ($package eq "Net::Jabber::Query") ||
        ($package eq "Net::Jabber::Data")) {
        my @xmlns = $self->{TREE}->XPath('@xmlns');
        my $xmlns = $xmlns[0];
        #&DEBUG($self,"xmlns(",$xmlns,")");
        #&DEBUG($self,"\%FUNCTIONS = \%{\$".$package."::NAMESPACES{\'".$xmlns."\'}}");
        if (defined($xmlns)) {
            eval "\%FUNCTIONS = \%{\$".$package."::NAMESPACES{\'".$xmlns."\'}}";

            @setFuncs = grep { exists($FUNCTIONS{$_}->{XPath}) && ($_ ne $value) } keys(%FUNCTIONS);

            ($XPathCall,@XPathArgs) = &XPathAutoLoad($self,$package,$value,$type,\@setFuncs,\%FUNCTIONS);
            return &{$CALLBACKS{"XPath".$type}}($self,@XPathArgs,@_) if ($XPathCall == 1);
        }
    }

    #-------------------------------------------------------------------------
    # If this is an AddXXX, NewXXX, or RemoveXXX then we need to handle that
    #-------------------------------------------------------------------------
     return eval("return &Net::Jabber::${AutoLoad}(\$self,\@_);")
        if (($AutoLoad eq "NewX") ||
            ($AutoLoad eq "NewQuery") ||
            ($AutoLoad eq "NewData") ||
            ($AutoLoad eq "AddX") ||
            ($AutoLoad eq "AddQuery") ||
            ($AutoLoad eq "AddData") ||
            ($AutoLoad eq "RemoveX") ||
            ($AutoLoad eq "RemoveQuery") ||
            ($AutoLoad eq "RemoveData")
           );
           
    #-------------------------------------------------------------------------
    # Finally, if it's not the debug function, then it doesn't exist.
    #-------------------------------------------------------------------------
     return &Net::Jabber::debug($self) if ($AutoLoad eq "debug");

    &Net::Jabber::MissingFunction($self,$AutoLoad);
}


##############################################################################
#
# NewX - calls AddX to create a new Net::Jabber::X object, sets the xmlns and
#        returns a pointer to the new object.
#
##############################################################################
sub NewX
{
    my $self = shift;
    my ($xmlns,$tag) = @_;
    $tag = "x" unless defined($tag);
    my $node = new XML::Stream::Node($tag);
    $node->put_attrib(xmlns=>$xmlns);
    return $self->AddX($node);
}


##############################################################################
#
# AddX - creates a new Net::Jabber::X object, pushes it on the list, and
#        returns a pointer to the new object.  This is a private helper
#        function.
#
##############################################################################
sub AddX
{
    my $self = shift;
    my $node = shift;
    my $x = new Net::Jabber::X($node);
    push(@{$self->{CHILDREN}->{x}},$x);
    return $x;
}


##############################################################################
#
# RemoveX - removes all xtags that have the specified namespace.
#
##############################################################################
sub RemoveX
{
    my $self = shift;
    my ($xmlns) = @_;

    foreach my $index (reverse(0..$#{$self->{CHILDREN}->{x}})) {
        splice(@{$self->{CHILDREN}->{x}},$index,1)
            if (!defined($xmlns) ||
                ($xmlns eq "") ||
                ($self->{CHILDREN}->{x}->[$index]->GetXMLNS() eq $xmlns));
    }
}


##############################################################################
#
# NewQuery - calls SetQuery to create a new Net::Jabber::Query object, sets
#            the xmlns and returns a pointer to the new object.
#
##############################################################################
sub NewQuery
{
    my $self = shift;
    my ($xmlns,$tag) = @_;
    $tag = "query" unless defined($tag);
    $self->RemoveQuery();
    my $node = new XML::Stream::Node($tag);
    $node->put_attrib(xmlns=>$xmlns);
    return $self->AddQuery($node);
}


##############################################################################
#
# AddQuery - creates a new Net::Jabber::Query object, sets the internal
#            pointer to it, and returns a pointer to the new object.  This
#            is a private helper function.
#
##############################################################################
sub AddQuery
{
    my $self = shift;
    my $node = shift;
    my $query = new Net::Jabber::Query($node);
    push(@{$self->{CHILDREN}->{query}},$query);
    return $query;
}


##############################################################################
#
# RemoveQuery - removes all querytags that have the specified namespace.
#
##############################################################################
sub RemoveQuery
{
    my $self = shift;
    my ($xmlns) = @_;

    foreach my $index (reverse(0..$#{$self->{CHILDREN}->{query}})) {
        splice(@{$self->{CHILDREN}->{query}},$index,1)
            if (!defined($xmlns) ||
                ($xmlns eq "") ||
                ($self->{CHILDREN}->{query}->[$index]->GetXMLNS() eq $xmlns));
    }
}


##############################################################################
#
# NewData - calls SetData to create a new Net::Jabber::Data object, sets
#            the xmlns and returns a pointer to the new object.
#
##############################################################################
sub NewData
{ 
    my $self = shift;
    my ($xmlns,$tag) = @_;
    $tag = "data" unless defined($tag);
    $self->RemoveData();
    my $node = new XML::Stream::Node($tag);
    $node->put_attrib(xmlns=>$xmlns);
    return $self->AddData($node);
}


##############################################################################
#
# AddData - creates a new Net::Jabber::Data object, sets the internal
#            pointer to it, and returns a pointer to the new object.  This
#            is a private helper function.
#
##############################################################################
sub AddData
{
    my $self = shift;
    my $node = shift;
    my $data = new Net::Jabber::Data($node);
    push(@{$self->{CHILDREN}->{data}},$data);
    return $data;
}


##############################################################################
#
# RemoveData - removes all datatags that have the specified namespace.
#
##############################################################################
sub RemoveData
{
    my $self = shift;
    my ($xmlns) = @_;

    foreach my $index (reverse(0..$#{$self->{CHILDREN}->{data}})) {
        splice(@{$self->{CHILDREN}->{data}},$index,1)
            if (!defined($xmlns) ||
                ($xmlns eq "") ||
                ($self->{CHILDREN}->{data}->[$index]->GetXMLNS() eq $xmlns));
    }
}


##############################################################################
#
# InsertRawXML - puts the specified string onto the list for raw XML to be
#                included in the packet.
#
##############################################################################
sub InsertRawXML
{
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
sub ClearRawXML
{
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
sub printData
{
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
sub sprintData
{
    my ($preString,$data) = @_;
    return &XML::Stream::sprintData(@_);
}


##############################################################################
#
# GetTimeStamp - generic funcion for getting a timestamp.
#
##############################################################################
sub GetTimeStamp
{
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
    ($sec,$min,$hour,$mday,$mon,$year,$wday) =
        localtime(((defined($time) && ($time ne "")) ? $time : time)) if ($type eq "local");
    ($sec,$min,$hour,$mday,$mon,$year,$wday) =
        gmtime(((defined($time) && ($time ne "")) ? $time : time)) if ($type eq "utc");

    return sprintf("%d%02d%02dT%02d:%02d:%02d",($year + 1900),($mon+1),$mday,$hour,$min,$sec) if ($length eq "stamp");

    $wday = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[$wday];

    my $month = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')[$mon];
    $mon++;

    return sprintf("%3s %3s %02d, %d %02d:%02d:%02d",$wday,$month,$mday,($year + 1900),$hour,$min,$sec) if ($length eq "long");
    return sprintf("%3s %d/%02d/%02d %02d:%02d",$wday,($year + 1900),$mon,$mday,$hour,$min) if ($length eq "normal");
    return sprintf("%02d:%02d:%02d",$hour,$min,$sec) if ($length eq "short");
    return sprintf("%02d:%02d",$hour,$min) if ($length eq "shortest");
}


##############################################################################
#
# GetHumanTime - convert seconds, into a human readable time string.
#
##############################################################################
sub GetHumanTime
{
    my $seconds = shift;

    my $minutes = 0;
    my $hours = 0;
    my $days = 0;
    my $weeks = 0;

    while ($seconds >= 60) {
        $minutes++;
        if ($minutes == 60) {
            $hours++;
            if ($hours == 24) {
                $days++;
                if ($days == 7) {
                    $weeks++;
                    $days -= 7;
                }
                $hours -= 24;
            }
            $minutes -= 60;
        }
        $seconds -= 60;
    }

    my $humanTime;
    $humanTime .= "$weeks week " if ($weeks == 1);
    $humanTime .= "$weeks weeks " if ($weeks > 1);
    $humanTime .= "$days day " if ($days == 1);
    $humanTime .= "$days days " if ($days > 1);
    $humanTime .= "$hours hour " if ($hours == 1);
    $humanTime .= "$hours hours " if ($hours > 1);
    $humanTime .= "$minutes minute " if ($minutes == 1);
    $humanTime .= "$minutes minutes " if ($minutes > 1);
    $humanTime .= "$seconds second " if ($seconds == 1);
    $humanTime .= "$seconds seconds " if ($seconds > 1);

    $humanTime = "none" if ($humanTime eq "");

    return $humanTime;
}

1;
