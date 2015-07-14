# install scribe

class scribe::install {
      
    package {
        'scribe.x86_64':
            ensure   => present,
    }


    package {
        'scribe-python.x86_64':
            ensure   => present,
    }

}

