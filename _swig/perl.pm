# This perl snippet is appended to the perl module generated by SWIG
# customizing and extending its functionality

package Finance::TA;

use strict;

our $VERSION = v0.4.0;

package Finance::TA::TA_RetCodeInfo;

# Redefine &new to a friendler version accepting an optional parameter
undef *new;

*new = sub {
    my ($pkg, $code) = @_;
    my $self = ::Finance::TAc::new_TA_RetCodeInfo();
    bless $self, $pkg if defined($self);
    ::Finance::TA::TA_SetRetCodeInfo($code, $self) if defined($code) && defined($self);
    return $self;
};

package Finance::TA::TA_FuncHandle;

sub new {
    my ($pkg, $name) = @_;
    my $self;
    my $retCode = ::Finance::TAc::TA_GetFuncHandle($name, \$self);
    if (defined $self) {
        bless $self, $pkg;
    }
    return $self;
}


sub GetFuncInfo {
    my ($self) = @_;
    my $info;
    my $retCode = ::Finance::TAc::TA_GetFuncInfo($self, \$info);
    return $info;
}


sub GetInputParameterInfo {
    my ($self, $param) = @_;
    my $info;
    my $retCode = ::Finance::TAc::TA_GetInputParameterInfo($self, $param, \$info);
    return $info;
}


sub GetOutputParameterInfo {
    my ($self, $param) = @_;
    my $info;
    my $retCode = ::Finance::TAc::TA_GetOutputParameterInfo($self, $param, \$info);
    return $info;
}


sub GetOptInputParameterInfo {
    my ($self, $param) = @_;
    my $info;
    my $retCode = ::Finance::TAc::TA_GetOptInputParameterInfo($self, $param, \$info);
    return $info;
}



package Finance::TA::TA_FuncInfo;

sub new {
    my ($pkg, $handle) = @_;
    my $self;
    my $retCode = ::Finance::TAc::TA_GetFuncInfo($handle, \$self);
    if (defined $self) {
        bless $self, $pkg;
    }
    return $self;
}


package Finance::TA;

# Redefine exported TA_Initialize/TA_Shutdown functions 
# to be more "Perl-friendly"

our $INITIALIZED = 0;

undef *TA_Initialize;

*TA_Initialize = sub {
    my $retCode;
    if ($INITIALIZED) {
        $retCode = TA_Shutdown();
        return $retCode if $retCode != $Finance::TA::TA_SUCCESS;
    }
    # Accept calls with no parameters
    $retCode = ::Finance::TAc::TA_Initialize();
    $INITIALIZED = ($retCode == $Finance::TA::TA_SUCCESS);
    return $retCode;
};

undef *TA_Shutdown;

*TA_Shutdown = sub {
    if ($INITIALIZED) {
        $INITIALIZED = 0;
        return ::Finance::TAc::TA_Shutdown();
    } else {
        # We are more forgiving on multiple calls to &TA_Shutdown
        # than TA-LIB on TA_Shutdown()
        return $Finance::TA::TA_SUCCESS;
    }
};

# SWIG does not export anything by default
# This small loop circumvents that and export everything beginning with 'TA_'
foreach (keys %Finance::TA::) {
    if (/^TA_/) {
        local *::sym = $Finance::TA::{$_};        
        push(@Finance::TA::EXPORT, "\$$_") if defined $::sym;
        push(@Finance::TA::EXPORT, "\@$_") if defined @::sym;
        push(@Finance::TA::EXPORT, "\%$_") if %::sym;
        push(@Finance::TA::EXPORT, $_) if defined &::sym;
    }
}

END { TA_Shutdown() }

TA_Initialize();
$INITIALIZED;
