# generated by clj2nix-1.0.7
{ pkgs }:

let repos = [
        "http://jcenter.bintray.com"
        "https://repo1.maven.org/maven2/"
        "https://repo.clojars.org/" ];

  in rec {
      fetchmaven = pkgs.callPackage (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/ba5e2222458a52357a3ba5873d88779d5c223269/pkgs/build-support/fetchmavenartifact/default.nix";
        sha512 = "05m7i8hbhyfz7p2f106mfbsasjf04svd9xkgc26pl3shljrk0dfacz39wiwzm6xqw7czgrsx745vciram7al621v7634nfdq3m1x88a";
      }) {};
      makePaths = {extraClasspaths ? null}:
        (pkgs.lib.concatMap
          (dep:
            builtins.map
            (path:
              if builtins.isString path then
                path
              else if builtins.hasAttr "jar" path then
                path.jar
              else if builtins.hasAttr "outPath" path then
                path.outPath
              else
                path
                )
            dep.paths)
          packages)
        ++ (if extraClasspaths != null then [ extraClasspaths ] else []);
      makeClasspaths = {extraClasspaths ? null}: builtins.concatStringsSep ":" (makePaths {inherit extraClasspaths;});
      packageSources = builtins.map (dep: dep.src) packages;
      packages = [
  rec {
    name = "javax.inject/javax.inject";
    src = fetchmaven {
      inherit repos;
      artifactId = "javax.inject";
      groupId = "javax.inject";
      sha512 = "e126b7ccf3e42fd1984a0beef1004a7269a337c202e59e04e8e2af714280d2f2d8d2ba5e6f59481b8dcd34aaf35c966a688d0b48ec7e96f102c274dc0d3b381e";
      version = "1";

    };
    paths = [ src ];
  }

  rec {
    name = "data.json/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "data.json";
      groupId = "org.clojure";
      sha512 = "a3a4465c4c5bc4968bd12b4bee46fc690f0952247fe6127b88244be3d996b5b63ac7920209b7e2145d76434c587d80de317c1a94084ed4a2431d51b7b1b11d73";
      version = "0.2.7";

    };
    paths = [ src ];
  }

  rec {
    name = "clojure/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "clojure";
      groupId = "org.clojure";
      sha512 = "f28178179483531862afae13e246386f8fda081afa523d3c4ea3a083ab607d23575d38ecb9ec0ee7f4d65cbe39a119f680e6de4669bc9cf593aa92be0c61562b";
      version = "1.10.1";

    };
    paths = [ src ];
  }

  rec {
    name = "commons-codec/commons-codec";
    src = fetchmaven {
      inherit repos;
      artifactId = "commons-codec";
      groupId = "commons-codec";
      sha512 = "e78265b77a4b69d8d66c45f98b70fb32d84b214a4323b86e9191ffc279bb271243b43b7d38edbc2ba8a1f319b6d642ab76a6c40c9681cea8b6ebd5b79c3a8b93";
      version = "1.13";

    };
    paths = [ src ];
  }

  rec {
    name = "api/com.cognitect.aws";
    src = fetchmaven {
      inherit repos;
      artifactId = "api";
      groupId = "com.cognitect.aws";
      sha512 = "e55709f5573cd8bf5e6df10caccddfe064bef4799656859fd6b69a3a2a312bc2a3570da14867017d3f573337e80c86e25ae0051a58a93734c45ac94ee717082d";
      version = "0.8.408";

    };
    paths = [ src ];
  }

  rec {
    name = "tools.analyzer/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.analyzer";
      groupId = "org.clojure";
      sha512 = "9cce94540a6fd0ae0bad915efe9a30c8fb282fbd1e225c4a5a583273e84789b3b5fc605b06f11e19d7dcc212d08bc6138477accfcde5d48839bec97daa874ce6";
      version = "0.6.9";

    };
    paths = [ src ];
  }

  rec {
    name = "plexus-component-annotations/org.codehaus.plexus";
    src = fetchmaven {
      inherit repos;
      artifactId = "plexus-component-annotations";
      groupId = "org.codehaus.plexus";
      sha512 = "cc534fda54272f074fe9edd581a6c3e1ea98127340c7f852c4b4953a44dad048ace22dfa10f30d6adcdfc15efd319dac778a03ebbe20de7779fd1df640506e88";
      version = "2.1.0";

    };
    paths = [ src ];
  }

  rec {
    name = "commons-compress/org.apache.commons";
    src = fetchmaven {
      inherit repos;
      artifactId = "commons-compress";
      groupId = "org.apache.commons";
      sha512 = "f3e077ff7f69992961d744dc513eca93606e472e3733657636808a7f50c17f39e3de8367a1af7972cb158f05725808627b6232585a81f197c0da3eff0336913e";
      version = "1.8";

    };
    paths = [ src ];
  }

  rec {
    name = "endpoints/com.cognitect.aws";
    src = fetchmaven {
      inherit repos;
      artifactId = "endpoints";
      groupId = "com.cognitect.aws";
      sha512 = "acef28d34d4b6d171b17f5b191262f6f29dee6c2221b147d59079311c6440fdfb552ea636f52c04716dd14d2fe0be62b524b419d160f7982f1d8616f4a0ed63e";
      version = "1.1.11.705";

    };
    paths = [ src ];
  }

  rec {
    name = "error_prone_annotations/com.google.errorprone";
    src = fetchmaven {
      inherit repos;
      artifactId = "error_prone_annotations";
      groupId = "com.google.errorprone";
      sha512 = "bd2135cc9eb2c652658a2814ec9c565fa3e071d4cff590cbe17b853885c78c9f84c1b7b24ba736f4f30ed8cec60a6af983827fcbed61ff142f27ac808e97fc6b";
      version = "2.1.3";

    };
    paths = [ src ];
  }

  rec {
    name = "commons-lang3/org.apache.commons";
    src = fetchmaven {
      inherit repos;
      artifactId = "commons-lang3";
      groupId = "org.apache.commons";
      sha512 = "fb0fe98385496a565678a000c26a3245082abfbf879cc29a35112b4bf18c966697a7a63bb1fd2fae4a42512cd3de5a2e6dc9d1df4a4058332a6ddeae06cdf667";
      version = "3.8.1";

    };
    paths = [ src ];
  }

  rec {
    name = "tools.logging/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.logging";
      groupId = "org.clojure";
      sha512 = "4601bfd9c63399cb1f58a67fafad900b0f6dc171b723c32f784b8344ea1d28cda13d64a6daf508afd443f6d924a25cbc1b3ae7b3b908dd09bacf0581baec178f";
      version = "0.5.0";

    };
    paths = [ src ];
  }

  rec {
    name = "core.specs.alpha/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "core.specs.alpha";
      groupId = "org.clojure";
      sha512 = "348c0ea0911bc0dcb08655e61b97ba040649b4b46c32a62aa84d0c29c245a8af5c16d44a4fa5455d6ab076f4bb5bbbe1ad3064a7befe583f13aeb9e32a169bf4";
      version = "0.2.44";

    };
    paths = [ src ];
  }

  rec {
    name = "xz/org.tukaani";
    src = fetchmaven {
      inherit repos;
      artifactId = "xz";
      groupId = "org.tukaani";
      sha512 = "c5c130bf22f24f61b57fc0c6243e7f961ca2a8928416e8bb288aec6650c1c1c06ace4383913cd1277fc6785beb9a74458807ea7e3d6b2e09189cfaf2fb9ab7e1";
      version = "1.5";

    };
    paths = [ src ];
  }

  rec {
    name = "spec.alpha/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "spec.alpha";
      groupId = "org.clojure";
      sha512 = "18c97fb2b74c0bc2ff4f6dc722a3edec539f882ee85d0addf22bbf7e6fe02605d63f40c2b8a2905868ccd6f96cfc36a65f5fb70ddac31c6ec93da228a456edbd";
      version = "0.2.176";

    };
    paths = [ src ];
  }

  rec {
    name = "tools.cli/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.cli";
      groupId = "org.clojure";
      sha512 = "7071cef2a92ad2d245c4fa5ec625f489738df2c320e8e50ceffb23d9927f006805b632e3086e9fd514ca7ff59ad0a7a2d98f3b0e5773258a71978053d0b85d6f";
      version = "1.0.194";

    };
    paths = [ src ];
  }

  rec {
    name = "animal-sniffer-annotations/org.codehaus.mojo";
    src = fetchmaven {
      inherit repos;
      artifactId = "animal-sniffer-annotations";
      groupId = "org.codehaus.mojo";
      sha512 = "9e5e3ea9e06e0ac9463869fd0e08ed38f7042784995a7b50c9bfd7f692a53f0e1430b9e1367dc772d0d4eafe5fd2beabbcc60da5008bd792f9e7ec8436c0f136";
      version = "1.14";

    };
    paths = [ src ];
  }

  rec {
    name = "jetty-http/org.eclipse.jetty";
    src = fetchmaven {
      inherit repos;
      artifactId = "jetty-http";
      groupId = "org.eclipse.jetty";
      sha512 = "d60a0e46e1110fbb52a31e5d41842bf252633ae9e132c224dbb633095043f4cbd9e3d06805e4bc1c82dc3842e3c1a1a62bb195f3e4ea811f36beb152fb3c37fa";
      version = "9.4.15.v20190215";

    };
    paths = [ src ];
  }

  rec {
    name = "jetty-util/org.eclipse.jetty";
    src = fetchmaven {
      inherit repos;
      artifactId = "jetty-util";
      groupId = "org.eclipse.jetty";
      sha512 = "ebd3f861991b755fc09a37e1f196cec064f2edd941b0aaf7e14947e9ca0f2e6a4c3bb41c6afbe39af6d76c6ae0de03663e543abf37e36444872d354047a5407c";
      version = "9.4.15.v20190215";

    };
    paths = [ src ];
  }

  rec {
    name = "jcl-over-slf4j/org.slf4j";
    src = fetchmaven {
      inherit repos;
      artifactId = "jcl-over-slf4j";
      groupId = "org.slf4j";
      sha512 = "0a703864b269de6f7bc98df0fa98aa943cc327a4ca2915899d460e4a071fcc3fbe70957eb91b740cc935d0960b3d98f30c54a0a4019d7ae8c6d50f51edb8d149";
      version = "1.7.25";

    };
    paths = [ src ];
  }

  rec {
    name = "tools.analyzer.jvm/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.analyzer.jvm";
      groupId = "org.clojure";
      sha512 = "ec1cb7638e38dfdca49c88e0b71ecf9c6ea858dccd46a2044bb37d01912ab4709b838cd2f0d1c2f201927ba4eea8f68d4d82e9fdd6da2f9943f7239bf86549f2";
      version = "0.7.2";

    };
    paths = [ src ];
  }

  rec {
    name = "jsch.agentproxy.jsch/com.jcraft";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsch.agentproxy.jsch";
      groupId = "com.jcraft";
      sha512 = "07e028fc7e47da2012116933d796ac75908e84eb5a42d8147aa11aa66c0c91ddd509628b19ad6603c7ce118a05e8985329fa0dc0dad7661d09ec5b3c76333ee0";
      version = "0.0.9";

    };
    paths = [ src ];
  }

  rec {
    name = "jsch.agentproxy.sshagent/com.jcraft";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsch.agentproxy.sshagent";
      groupId = "com.jcraft";
      sha512 = "0898f33a1eae03ab3b0d78ad26076756ec0eec456e185b7d5057e003b33e0cb1b2ca57b8c4cdca48eae544daf36adcabd170138e5950b85ab8b64c97c094ba9d";
      version = "0.0.9";

    };
    paths = [ src ];
  }

  rec {
    name = "jackson-dataformat-cbor/com.fasterxml.jackson.dataformat";
    src = fetchmaven {
      inherit repos;
      artifactId = "jackson-dataformat-cbor";
      groupId = "com.fasterxml.jackson.dataformat";
      sha512 = "575a00fec1760571403aaadbe0aa6c74f8bb01f40feae00741df6604e7c2bf199ac739a789bbd5d83af75ec6d9fcc55f5a1515b05aef33e0d3cc3046acad9e89";
      version = "2.10.2";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-resolver-transport-http/org.apache.maven.resolver";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-resolver-transport-http";
      groupId = "org.apache.maven.resolver";
      sha512 = "b5fb4eae069028c1ae7f00309986f487272a9bad1e637a5eb58dcd269421bb1194f0f18cb9c8cedc84b81d936e4b73327699584ed35d64bdc0e912e8f64661c7";
      version = "1.4.1";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-model-builder/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-model-builder";
      groupId = "org.apache.maven";
      sha512 = "d65f71a4c755be518061fc2d33582c3da422cb3d52a01cd68bdf906c0fc4bfc1977da7714f9622452a02d34e00b7d4b1b1e4986bb59cbfdc5333bf12c9c7e699";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "JavaEWAH/com.googlecode.javaewah";
    src = fetchmaven {
      inherit repos;
      artifactId = "JavaEWAH";
      groupId = "com.googlecode.javaewah";
      sha512 = "fea689d1e29761ce90c860ee3650c4167ae9e5ecaa316247bdafac5833bce48d2b3e04e633b426e3ab7ef3a5c9c7fd150ffa0c21afdcae9c945cb2bb85f8a82f";
      version = "1.1.6";

    };
    paths = [ src ];
  }

  rec {
    name = "plexus-utils/org.codehaus.plexus";
    src = fetchmaven {
      inherit repos;
      artifactId = "plexus-utils";
      groupId = "org.codehaus.plexus";
      sha512 = "354f185cb3c6ade3f2d3f27c1a27a811922782ca4bd74a997c9c922dc7a2d44148ce6f141f16c0c1ab8f7988dd8a30602713d558606d088e8ba82a0ec1fb55a5";
      version = "3.2.1";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-resolver-transport-file/org.apache.maven.resolver";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-resolver-transport-file";
      groupId = "org.apache.maven.resolver";
      sha512 = "0ef5358144e87441c02b94a29d194e4951af2772cacd6ac8d41f502e621dc78e622c7c5bd366a98e12c2b4a70517d25f83f55427f93e61dfd41671f11f0b565c";
      version = "1.4.1";

    };
    paths = [ src ];
  }

  rec {
    name = "org.eclipse.sisu.plexus/org.eclipse.sisu";
    src = fetchmaven {
      inherit repos;
      artifactId = "org.eclipse.sisu.plexus";
      groupId = "org.eclipse.sisu";
      sha512 = "f76b33d4c0acfb90357736b8466016661924351332e1db6eaff5bd15398e7765acec328dd3e94d37b66c9881a54bbed23571590363c46ee78f5d1acbad36c95b";
      version = "0.3.4";

    };
    paths = [ src ];
  }

  rec {
    name = "jsch.agentproxy.usocket-jna/com.jcraft";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsch.agentproxy.usocket-jna";
      groupId = "com.jcraft";
      sha512 = "3213e63895552aa33858ece929c84c140ea95d6c3835c88e150cd37f266fb69b48b9ff9921132c808d1909ad0e97dd497a28a34d051a0a8c06c18b5a0d5f2850";
      version = "0.0.9";

    };
    paths = [ src ];
  }

  rec {
    name = "commons-io/commons-io";
    src = fetchmaven {
      inherit repos;
      artifactId = "commons-io";
      groupId = "commons-io";
      sha512 = "1f6bfc215da9ae661dbabba80a0f29101a2d5e49c7d0c6ed760d1cafea005b7f0ff177b3b741e75b8e59804b0280fa453a76940b97e52b800ec03042f1692b07";
      version = "2.5";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-settings-builder/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-settings-builder";
      groupId = "org.apache.maven";
      sha512 = "f9f9f538a409d7cf2bd2517854f2d6aa45e0476865f217a11832f042ec361c67998241065540c3269d3db3915c903b15b6e4fb57af9623b192f9d8089110ecbc";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "tools.namespace/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.namespace";
      groupId = "org.clojure";
      sha512 = "8ace6a7be0d9b49b01dd4e642e1315521afaee2fc55bdf4a334efa1427efae7e8db02ef93c38a5d7a6fe00134c24930aba13d6a5ceb373945ed15dc8ee250168";
      version = "1.0.0";

    };
    paths = [ src ];
  }

  rec {
    name = "org.eclipse.jgit/org.eclipse.jgit";
    src = fetchmaven {
      inherit repos;
      artifactId = "org.eclipse.jgit";
      groupId = "org.eclipse.jgit";
      sha512 = "19ca3301391a4d4a6ca9c8ad2c936040497ee79b7c1e59c768636cf5d89f27329f808f8daaa74771bdedb877d694d9ae44dc8f94a932f4054d0c471efccf69d9";
      version = "4.10.0.201712302008-r";

    };
    paths = [ src ];
  }

  rec {
    name = "jackson-core/com.fasterxml.jackson.core";
    src = fetchmaven {
      inherit repos;
      artifactId = "jackson-core";
      groupId = "com.fasterxml.jackson.core";
      sha512 = "5055943790cea2c3abbacbe91e63634e6d2e977cd59b08ce102c0ee7d859995eb5d150d530da3848235b2b1b751a8df55cff2c33d43da695659248187ddf1bff";
      version = "2.10.2";

    };
    paths = [ src ];
  }

  rec {
    name = "cdi-api/javax.enterprise";
    src = fetchmaven {
      inherit repos;
      artifactId = "cdi-api";
      groupId = "javax.enterprise";
      sha512 = "3e326196a2cbf19375803ce37d743a9818c4fa2292914439e748060d6889c997fe33077f52e52d4dd61b60e7342aa31b446d7571a92ec864f44cead45ebd612b";
      version = "1.0";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-settings/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-settings";
      groupId = "org.apache.maven";
      sha512 = "dae78e5bedde2009c8a7fdf0b77c91b87b8c4c4cb5bc73f799107edd75597a3c90dc497abdfa43254e7dc31eb7707384254d91fb656c74bb5d86cd868e36209b";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "httpcore/org.apache.httpcomponents";
    src = fetchmaven {
      inherit repos;
      artifactId = "httpcore";
      groupId = "org.apache.httpcomponents";
      sha512 = "7f58003e9eec977627401c4c6bc720af257094f492b0f73c43fb547e0d161017657f5c9c0b834704c5c00112b91e88ee9e4c255cc1e31aa62ba979d21393aed4";
      version = "4.4.10";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-core/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-core";
      groupId = "org.apache.maven";
      sha512 = "fe0e2bd7c34267f7c8139d996bee99f41d29bcb6d1bbedbceb055eda31355ef179ed5e319fa97496eb85499bfc5f8738f7ac7f2c17a7118cb87cfacd984708de";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "plexus-cipher/org.sonatype.plexus";
    src = fetchmaven {
      inherit repos;
      artifactId = "plexus-cipher";
      groupId = "org.sonatype.plexus";
      sha512 = "deb948be3a9f6a2fa74adca17e54b1074948267b3a35dd4000d92c559d0387650770ccee096ad8f01dd51c36caf63878dc0bcf57dfb1f2e3e1a9d51204096617";
      version = "1.4";

    };
    paths = [ src ];
  }

  rec {
    name = "jsch.agentproxy.pageant/com.jcraft";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsch.agentproxy.pageant";
      groupId = "com.jcraft";
      sha512 = "d141c49675f7f16ea4eacbf8c426764aa28bfacc598f07b72fd10228565000954e6fad5334ffa5e20b7f4400f2dd5641aa39e99b8e8dceaf12c9dfa39930074c";
      version = "0.0.9";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-resolver-api/org.apache.maven.resolver";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-resolver-api";
      groupId = "org.apache.maven.resolver";
      sha512 = "da56ddeecfbb6d285d08fa60f88fe125d1f08f48ea24013b83b6aadf24835c034c9b45cdb815d99505b35e0605c48b6d7e5949f1735a874049b0790e8a8461dc";
      version = "1.4.1";

    };
    paths = [ src ];
  }

  rec {
    name = "jsr250-api/javax.annotation";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsr250-api";
      groupId = "javax.annotation";
      sha512 = "8b5dd24460e42763f3645205be4b4f80691e217d36bee5fc5b5df6ebc8782ed0f641fb9e2fe918a2d0eede32556656f6b61fe65d2cbec5086e61ef3d91e4d871";
      version = "1.0";

    };
    paths = [ src ];
  }

  rec {
    name = "http-client/com.cognitect";
    src = fetchmaven {
      inherit repos;
      artifactId = "http-client";
      groupId = "com.cognitect";
      sha512 = "1356c32e45ca622bad1b46b3821237c06c701cc0a04b113d7dc92655158844cd9a2f043d835c0d77648222a092c87aae3f993c728829128e74ca11cce8120baf";
      version = "0.1.101";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-resolver-provider/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-resolver-provider";
      groupId = "org.apache.maven";
      sha512 = "9febca461a031acd195b96b05fea2f28333a2cb587119a5493a3e9061af87bed4e7e1619acce9a505ad579a71f0a5e740cf78a3642095c2bc45a3d73c358e226";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "checker-compat-qual/org.checkerframework";
    src = fetchmaven {
      inherit repos;
      artifactId = "checker-compat-qual";
      groupId = "org.checkerframework";
      sha512 = "fdecc20efd6943426e7f8bdfb8bef9d28258f9f934cf29090e2f5b297c501454606cc28593cd7d089a5c14f6d2dcafc59f4606053405d7f91d623a0e3202f4a8";
      version = "2.0.0";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-shared-utils/org.apache.maven.shared";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-shared-utils";
      groupId = "org.apache.maven.shared";
      sha512 = "4cab9de8654b3744ceb1a62b51853e076c191cae8193e8393a979cd428833b994ceed591806960e100942dde3eeb65538169d42666004e3623b6129475fe2cab";
      version = "3.2.1";

    };
    paths = [ src ];
  }

  rec {
    name = "java.classpath/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "java.classpath";
      groupId = "org.clojure";
      sha512 = "90cd8edeaea02bd908d8cfb0cf5b1cf901aeb38ea3f4971c4b813d33210438aae6fff8e724a8272d2ea9441d373e7d936fa5870e309c1e9721299f662dbbdb9a";
      version = "1.0.0";

    };
    paths = [ src ];
  }

  rec {
    name = "tools.deps.alpha/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.deps.alpha";
      groupId = "org.clojure";
      sha512 = "9a6b8ffa724c3afe81ac0e59d0dd1e0cc7f1dbe5c776a75399b9628bd128523d868364f8a13a7e329deefdd0b910ba073addf342ce5ccee387edf0198ccac738";
      version = "0.9.755";

    };
    paths = [ src ];
  }

  rec {
    name = "environ/environ";
    src = fetchmaven {
      inherit repos;
      artifactId = "environ";
      groupId = "environ";
      sha512 = "e318da117facf51a27b9ae39279363c4d824393215ce63fa69e5bdb65a910d1f8632d712598ad0c3f4248d0ab9274a97161859393d265d74d50ad2a4cdbddf41";
      version = "1.2.0";

    };
    paths = [ src ];
  }

  rec {
    name = "guava/com.google.guava";
    src = fetchmaven {
      inherit repos;
      artifactId = "guava";
      groupId = "com.google.guava";
      sha512 = "c8f95af9f1e97dee807503c8fbb442c87eed2694e43ad0fd9fc2e62ba99c5e93d476d5ee8f4791f173cb8fdabc88abac0e8130a51de280af836a3e0c4eadaff6";
      version = "25.1-android";

    };
    paths = [ src ];
  }

  rec {
    name = "data.xml/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "data.xml";
      groupId = "org.clojure";
      sha512 = "12ea6e7ee27be4a0329a766f3449f3e3b756772e3cd8588b4666bb175faaabd0780b96300b10e17ccb3016b0ba5d9f020c7d976211ff398e7bebef718aa4d5f5";
      version = "0.2.0-alpha6";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-resolver-spi/org.apache.maven.resolver";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-resolver-spi";
      groupId = "org.apache.maven.resolver";
      sha512 = "250bccfb03d380b0fa64996e7911fa1c58253f28d933746487b8c0b04474bb2d72afb0360656f651a487fac065ce78c966b059d8aab358e8ba3593aca1eeae0e";
      version = "1.4.1";

    };
    paths = [ src ];
  }

  rec {
    name = "j2objc-annotations/com.google.j2objc";
    src = fetchmaven {
      inherit repos;
      artifactId = "j2objc-annotations";
      groupId = "com.google.j2objc";
      sha512 = "a4a0b58ffc2d9f9b516f571bcd0ac14e4d3eec15aacd6320a4a1a12045acce8c6081e8ce922c4e882221cedb2cc266399ab468487ae9a08124d65edc07ae30f0";
      version = "1.1";

    };
    paths = [ src ];
  }

  rec {
    name = "plexus-classworlds/org.codehaus.plexus";
    src = fetchmaven {
      inherit repos;
      artifactId = "plexus-classworlds";
      groupId = "org.codehaus.plexus";
      sha512 = "6a58048d9db54e603b9cfd35373cf695b66dd860bec878c663b4fc53b6b3d44dd5b0c92e7603654911b1f78e63ef277cf6b272fe069a360989138550545f274d";
      version = "2.6.0";

    };
    paths = [ src ];
  }

  rec {
    name = "plexus-sec-dispatcher/org.sonatype.plexus";
    src = fetchmaven {
      inherit repos;
      artifactId = "plexus-sec-dispatcher";
      groupId = "org.sonatype.plexus";
      sha512 = "5b947edcb05a1c17648ec9fe53dd2c66b4a86dd2b950d989255f6edd636fd5d50d18b8f31b3a1736dadd9cff6790a3d0355f2ed896c3eb7f72e009199fe9957d";
      version = "1.4";

    };
    paths = [ src ];
  }

  rec {
    name = "plexus-interpolation/org.codehaus.plexus";
    src = fetchmaven {
      inherit repos;
      artifactId = "plexus-interpolation";
      groupId = "org.codehaus.plexus";
      sha512 = "fb647c1f159d17e16ae925bb407585e4a4b30c468518e60d3069ea4a75fa0f7122e789923534632125b22b7cef1cb44caf00700bba90282360f7c76e086b6699";
      version = "1.25";

    };
    paths = [ src ];
  }

  rec {
    name = "httpclient/org.apache.httpcomponents";
    src = fetchmaven {
      inherit repos;
      artifactId = "httpclient";
      groupId = "org.apache.httpcomponents";
      sha512 = "32cb1ee6e34c883ff7f4ade7eaf563152962b0e40e6795f93d1600ffe1ced7102062c8d0c2c31f4fc9606f1f500ea554e5d83b7ae650c1d78a3be312808e6f35";
      version = "4.5.6";

    };
    paths = [ src ];
  }

  rec {
    name = "jna/net.java.dev.jna";
    src = fetchmaven {
      inherit repos;
      artifactId = "jna";
      groupId = "net.java.dev.jna";
      sha512 = "ea1b400cf25c6032160553f19baedb21103341f1c4236fbecf5f8462cc4db06f3459d7812ed0ad07a0b9faa3b576f8fa6edbd9ed64f9486b85e5bf982c21775e";
      version = "4.1.0";

    };
    paths = [ src ];
  }

  rec {
    name = "guice/com.google.inject";
    src = fetchmaven {
      inherit repos;
      artifactId = "guice";
      groupId = "com.google.inject";
      sha512 = "51eec8b514cb7b4f05b8e5846e4cfe5dfc42a3e3171ced079a83e122e7113d96defc6edfada375e072f965b01450e170072b1f85fcd11800804239b93c2878dd";
      version = "4.2.1";
      classifier = "no_aop";
    };
    paths = [ src ];
  }

  rec {
    name = "cheshire/cheshire";
    src = fetchmaven {
      inherit repos;
      artifactId = "cheshire";
      groupId = "cheshire";
      sha512 = "5b2a339f8d90951a80105729a080b841e0de671f576bfa164a78bccc08691d548cff6a7124224444f7b3a267c9aca69c18e347657f1d66e407167c9b5b8b52cb";
      version = "5.10.0";

    };
    paths = [ src ];
  }

  rec {
    name = "tigris/tigris";
    src = fetchmaven {
      inherit repos;
      artifactId = "tigris";
      groupId = "tigris";
      sha512 = "fdff4ef5e7175a973aaef98de4f37dee8e125fc711c495382e280aaf3e11341fe8925d52567ca60f3f1795511ade11bc23461c88959632dfae3cf50374d02bf6";
      version = "0.1.2";

    };
    paths = [ src ];
  }

  rec {
    name = "jsch.agentproxy.connector-factory/com.jcraft";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsch.agentproxy.connector-factory";
      groupId = "com.jcraft";
      sha512 = "b4268c6d91899ffb82d5854eaef7c2bf7db3e1e223446d6ca10ae5d88174f944994e2d098582b6dd9ac0e45feacb9e52dd58ea9e41f4ff9b2241cbc5226fa567";
      version = "0.0.9";

    };
    paths = [ src ];
  }

  rec {
    name = "jetty-client/org.eclipse.jetty";
    src = fetchmaven {
      inherit repos;
      artifactId = "jetty-client";
      groupId = "org.eclipse.jetty";
      sha512 = "9a1e4463542973c6944becddc8a38ba2735a8b344605b0befdbae628c6a842d2128f7c56e1b88f2e45352ffbc0c8ab78242a1057baae7590c22117cb5a43d7df";
      version = "9.4.15.v20190215";

    };
    paths = [ src ];
  }

  rec {
    name = "jetty-io/org.eclipse.jetty";
    src = fetchmaven {
      inherit repos;
      artifactId = "jetty-io";
      groupId = "org.eclipse.jetty";
      sha512 = "9d03f6250f61f79bdcb116f03c610a168c53879b68c2ba68a5f902f2efb5a6b957c97fd3d8c4c05a65441f1ed56db12f7d83a9bb1cda831d70a3cda43b96a68d";
      version = "9.4.15.v20190215";

    };
    paths = [ src ];
  }

  rec {
    name = "tools.reader/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.reader";
      groupId = "org.clojure";
      sha512 = "290a2d98b2eec08a8affc2952006f43c0459c7e5467dc454f5fb5670ea7934fa974e6be19f7e7c91dadcfed62082d0fbcc7788455b7446a2c9c5af02f7fc52b6";
      version = "1.3.2";

    };
    paths = [ src ];
  }

  rec {
    name = "jna-platform/net.java.dev.jna";
    src = fetchmaven {
      inherit repos;
      artifactId = "jna-platform";
      groupId = "net.java.dev.jna";
      sha512 = "8ab09d04fd7e86b505f917e0a2b11d2c2e9f3a3e923a9fb94ad7e0bf6715f1923e02d8f3927f9580ab9f39f9fa213176013c3bcd977c2d1ef6461e2610571455";
      version = "4.1.0";

    };
    paths = [ src ];
  }

  (rec {
    name = "clj.native-image/clj.native-image";
    src = pkgs.fetchgit {
      name = "clj.native-image";
      url = "https://github.com/taylorwood/clj.native-image.git";
      rev = "4604ae76855e09cdabc0a2ecc5a7de2cc5b775d6";
      sha256 = "16wwwz8iykn86kc79scg9cannz0y2f07qdi9bsm0nkwbh1lfshka";
    };
    paths = map (path: src + path) [
      "/src"
    ];
  })

  rec {
    name = "tools.gitlibs/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "tools.gitlibs";
      groupId = "org.clojure";
      sha512 = "acfdf53a6ba032b1df749ad755f3bb55cf0bb21f03e08be3f72b6b4de75aa9e8875f3137f992a855bb22785612bcacd76d7208be15d67588d93bf826478599c2";
      version = "1.0.91";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-resolver-connector-basic/org.apache.maven.resolver";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-resolver-connector-basic";
      groupId = "org.apache.maven.resolver";
      sha512 = "ff8e2d8a1abd7f1273997f0cff8156cd409df9d3144515efafc1a4157b49b7055b27237e2055c3814a790b3e53eb82402d3ce4e09fa6644b45da185f2b90a8ff";
      version = "1.4.1";

    };
    paths = [ src ];
  }

  rec {
    name = "s3/com.cognitect.aws";
    src = fetchmaven {
      inherit repos;
      artifactId = "s3";
      groupId = "com.cognitect.aws";
      sha512 = "209c1b5da97163da0980abdf2c3523e5037e13d1d7e3467a565271d4c61e51c9958d5e1beb7a8c6163a6ffc0e312e4724f9ace8a3ac545ce385dd056d6d5b5da";
      version = "784.2.593.0";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-resolver-impl/org.apache.maven.resolver";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-resolver-impl";
      groupId = "org.apache.maven.resolver";
      sha512 = "d3132d89be995b13c81ddcca34f4cb22128a774ab133d685369b685e945cdb5c6a4a539cc67043bcf1d11a15f7fc417c464f7c1b34774c2abe7e430cc30c4347";
      version = "1.4.1";

    };
    paths = [ src ];
  }

  rec {
    name = "slf4j-api/org.slf4j";
    src = fetchmaven {
      inherit repos;
      artifactId = "slf4j-api";
      groupId = "org.slf4j";
      sha512 = "ca99cb8f73875eac2fbdb8b13b9801d1299dd3e93556bd002ec2f2c906fd88e4450b9cf4ab025951944fc490d03ff691189fb174440bd3f404e9717276b6f9e6";
      version = "1.7.29";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-model/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-model";
      groupId = "org.apache.maven";
      sha512 = "7df3d781dd0c3a5947c76a02bb811d2bff0eb9bd0ba1efc3a55001576c58612bb1fd221ceb9cedd7ed84dfdb64c973b61af22c56636e1cfb03a55cfbe83655f6";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "org.eclipse.sisu.inject/org.eclipse.sisu";
    src = fetchmaven {
      inherit repos;
      artifactId = "org.eclipse.sisu.inject";
      groupId = "org.eclipse.sisu";
      sha512 = "cfd6be3e9f160258682662325757a8b95303045e37708f4226f40aaef01c8a5e4ff5a275715e4d740e2feae462e3b76f53c360507c1f738bec0157d2c226a46a";
      version = "0.3.4";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-resolver-util/org.apache.maven.resolver";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-resolver-util";
      groupId = "org.apache.maven.resolver";
      sha512 = "35a0b284fefad99b77c60f15d091c1bad3417baad1fc86fb6850a347a8a75a9cea26fa227ec601577f4096184b82ce198b4472441e95fce556f7d332c6a155cb";
      version = "1.4.1";

    };
    paths = [ src ];
  }

  rec {
    name = "fs/me.raynes";
    src = fetchmaven {
      inherit repos;
      artifactId = "fs";
      groupId = "me.raynes";
      sha512 = "b72af0093c1feccf78ea0632ba523eca89436b0575abc0af484e03570011aa89f429f9820a9fc27f60da113d728d2bbc09ba26d3a0cdd63d9d9c7775643f6852";
      version = "1.4.6";

    };
    paths = [ src ];
  }

  rec {
    name = "core.memoize/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "core.memoize";
      groupId = "org.clojure";
      sha512 = "e1c5104ac20a22e670ccb80c085ce225c168802829668e91c316cbea4f8982431a9e2ac7bfa5e8477ef515088e9443763f44496633c8ee1e416f7eb8ddfefb88";
      version = "0.5.9";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-repository-metadata/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-repository-metadata";
      groupId = "org.apache.maven";
      sha512 = "9fbaffa07e4bfc091d4d8818330481bdc9d1d96448087321bb2914aac10ccb1c7b5cc6be0f6c76b8c0232b9cb69e4cdeec4fe40df5e9f2d472a4a027e5a3b3f9";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "data.priority-map/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "data.priority-map";
      groupId = "org.clojure";
      sha512 = "450e18bddb3962aee3a110398dc3e9c25280202eb15df2f25de6c26e99982e8de5cf535fe609948d190e312a00fad3ffc0b3a78b514ef66369577a4185df0a77";
      version = "0.0.7";

    };
    paths = [ src ];
  }

  rec {
    name = "aopalliance/aopalliance";
    src = fetchmaven {
      inherit repos;
      artifactId = "aopalliance";
      groupId = "aopalliance";
      sha512 = "3f44a932d8c00cfeee2eb057bcd7c301a2d029063e0a916e1e20b3aec4877d19d67a2fd8aaf58fa2d5a00133d1602128a7f50912ffb6cabc7b0fdc7fbda3f8a1";
      version = "1.0";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-builder-support/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-builder-support";
      groupId = "org.apache.maven";
      sha512 = "1f72981bf568facf16865dbfb1d5955ecbf82d90b5ed3da2bc096fb7e0f67056202d16078d9ad46945de9b59846aadc8ac010d23ab374dffbef5e7534bdbf1fd";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "jsr305/com.google.code.findbugs";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsr305";
      groupId = "com.google.code.findbugs";
      sha512 = "bb09db62919a50fa5b55906013be6ca4fc7acb2e87455fac5eaf9ede2e41ce8bbafc0e5a385a561264ea4cd71bbbd3ef5a45e02d63277a201d06a0ae1636f804";
      version = "3.0.2";

    };
    paths = [ src ];
  }

  rec {
    name = "jsch/com.jcraft";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsch";
      groupId = "com.jcraft";
      sha512 = "97ec6de64f4870ee3c84f883bd3664562bfd600ca9f3364966e7dbee7e4e8520647c03f9f81d6808e330052ca1333e37f497d6252cd26fe721a90f573cbe2036";
      version = "0.1.54";

    };
    paths = [ src ];
  }

  rec {
    name = "jsch.agentproxy.core/com.jcraft";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsch.agentproxy.core";
      groupId = "com.jcraft";
      sha512 = "b397effe92c9a93012ece3eb7660aacce3cef1c07d2b176cfcb7f7d8d735d22ca0c968e76fb36cb2a311566ee4b23982126671bff9baf11b4786606f2a6a0c81";
      version = "0.0.9";

    };
    paths = [ src ];
  }

  rec {
    name = "jsch.agentproxy.usocket-nc/com.jcraft";
    src = fetchmaven {
      inherit repos;
      artifactId = "jsch.agentproxy.usocket-nc";
      groupId = "com.jcraft";
      sha512 = "b1c67975955bc2ef240e05ecb4c82335f40b038ee4483190e346f633ca1b78de9bfb848a5bee803971acf6b7282b2343461a12615257b2fcb01e7e2c349fc084";
      version = "0.0.9";

    };
    paths = [ src ];
  }

  rec {
    name = "core.cache/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "core.cache";
      groupId = "org.clojure";
      sha512 = "464c8503229dfcb5aa3c09cd74fa273ae82aff7a8f8daadb5c59a4224c7d675da4552ee9cb28d44627d5413c6f580e64df4dbfdde20d237599a46bb8f9a4bf6e";
      version = "0.6.5";

    };
    paths = [ src ];
  }

  rec {
    name = "asm-all/org.ow2.asm";
    src = fetchmaven {
      inherit repos;
      artifactId = "asm-all";
      groupId = "org.ow2.asm";
      sha512 = "462f31f8889c5ff07f1ce7bb1d5e9e73b7ec3c31741dc2b3da8d0b1a50df171e8e72289ff13d725e80ecbd9efa7e873b09870f5e8efb547f51f680d2339f290d";
      version = "4.2";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-plugin-api/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-plugin-api";
      groupId = "org.apache.maven";
      sha512 = "07090ed707bb3364219da130bc7b38a2a2b9fd31bae51144202b52e5e9f8d9690e8b3fe360bb3327fbeaed3b555c42b52144fb87a5854c8ca2226c07d62e0ed6";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "core.async/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "core.async";
      groupId = "org.clojure";
      sha512 = "0b04dcc955a00f53d4304cc0b0c465955775fec2a5c499159d4b2b6bd0408b48acada78b66a304ece0015d4c1822db53483d8bc575ab8cea8bc50d456381b842";
      version = "0.5.527";

    };
    paths = [ src ];
  }

  rec {
    name = "jackson-dataformat-smile/com.fasterxml.jackson.dataformat";
    src = fetchmaven {
      inherit repos;
      artifactId = "jackson-dataformat-smile";
      groupId = "com.fasterxml.jackson.dataformat";
      sha512 = "8998346f7039df868f3387d219efa0c04fc022a948d098296f3d7ac3f7a9a82bde6ec4a8f83b11994ad50318b5aca37781faacb1f20a65ba2ecc6d6d6eb9468e";
      version = "2.10.2";

    };
    paths = [ src ];
  }

  rec {
    name = "maven-artifact/org.apache.maven";
    src = fetchmaven {
      inherit repos;
      artifactId = "maven-artifact";
      groupId = "org.apache.maven";
      sha512 = "53726aee76ea01de2253c623292f64b5bf7784c6e223ebcc7548a2136922cbdf69d3bc42c44d00e6fe2015d2304b67d02d7a988d400da2ed036d489c6ed8fbe6";
      version = "3.6.3";

    };
    paths = [ src ];
  }

  rec {
    name = "data.codec/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "data.codec";
      groupId = "org.clojure";
      sha512 = "c324b62a5f14b2f17e49f1b0fffa3f44d195cb5261e03c5e472ba4f2972135f4b06fd321c0887717c727f025fc1a0121283d16fbf923d7469856702614a288f3";
      version = "0.1.0";

    };
    paths = [ src ];
  }

  ];
  }