<div class="container">

    <div class="row">

<div class="col-md-2 col-sm-6" style="max-height:40em; overflow:auto">

<div class="panel-group" id="profs">
    {foreach from=$listeProfs key=initiale item=desProfs}
    {assign var=first value=$desProfs[$desProfs|@key].nom|truncate:5:'..'}
    {assign var=last value=$desProfs[$desProfs|array_reverse|@key].nom|truncate:5:'..'}

      <div class="panel panel-default">

        <div class="panel-heading">
          <h4 class="panel-title">
            <a data-toggle="collapse" data-parent="#" href="#{$initiale}">
              <button type="button" class="btn btn-default btn-block">{$first} {$last}</button>
            </a>
          </h4>
        </div>
        <div id="{$initiale}" class="panel-collapse collapse">
          <div class="panel-body">
              <ul class="list-unstyled">
                  {foreach from=$desProfs key=abr item=data}
                  <li title="{$data.nom} {$data.prenom}">
                      <button
                          type="button"
                          class="btn btn-sm btn-block btn-prof{if (isset($acronyme)) && ($abr == $acronyme)} btn-primary{else btn-default}{/if}"
                          data-abreviation="{$data.acronyme}"
                          data-nomprof="{$data.prenom} {$data.nom}"
                          data-statut="{$data.statut}">
                          {$data.nom} {$data.prenom}
                      </button>
                  </li>
                  {/foreach}

              </ul>

          </div>
        </div>
      </div>
    {/foreach}
</div>

</div>  <!-- col-md-... -->


        <div class="col-md-7 col-sm-6">

            <!-- liste des RV et liste d'attente -->
            <div id="listeRV" style="max-height:40em; overflow: auto">
                {if isset($listeRV)}
                    {include file="reunionParents/tableRVAdmin.tpl"}
                {/if}
            </div>

            <div id="listeAttenteProf">
                {if isset($listeAttente)}
                    {include file="reunionParents/listeAttenteAdmin.tpl"}
                {/if}
            </div>

        </div>
        <!-- col-md-... -->


        <div class="col-md-3 col-sm-12">

            <div id="listeEleves" style="max-height: 40em; overflow:auto;">
                {if isset($listeEleves)} {include file="reunionParents/listeElevesProf.tpl"} {/if}
            </div>

        </div>
        <!-- col-md-... -->

    </div>
    <!-- row -->

    {include file="reunionParents/modal/modalDelRV.tpl"} {include file="reunionParents/modal/modalMaxRV.tpl"} {include file="reunionParents/modal/modalDoublonRV.tpl"} {include file="reunionParents/modal/modalAttente.tpl"} {include file="reunionParents/modal/modalElevePlz.tpl"} {include file="reunionParents/modal/modalHeureRvPlz.tpl"}

</div>
<!-- container -->


<script type="text/javascript">

    $(document).ready(function() {

        // sélection d'un prof
        $(document).on('click', '.btn-prof', function() {
            var acronyme = $(this).data('abreviation');
            var date = $("#date").val();
            var nomProf = $(this).data('nomprof');
            var statut = $(this).data('statut');
            $(".btn-prof").removeClass('btn-primary');
            $(this).addClass('btn-primary');
            // produire la liste des RV pour le prof désigné
            $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                        acronyme: acronyme,
                        date: date,
                    },
                    function(resultat) {
                        $("#listeRV").html(resultat);
                    }
                )
            // produire la liste d'attente admin pour ce prof
            $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                        date: date,
                        acronyme: acronyme
                    },
                    function(resultat) {
                        $("#listeAttenteProf").html(resultat);
                    }
                )
            // produire la liste des élèves possibles pour un prof donné
            $.post('inc/reunionParents/listeEleves.inc.php', {
                    acronyme: acronyme,
                    statut: statut
                },
                function(resultat) {
                    $("#listeEleves").html(resultat);
                }
            )
        })

        // attribution d'un RV à un élève
        $("#listeRV").on('click', '.lien', function() {
            var id = $(this).data('id');
            var matricule = $('.btn-eleve.btn-primary').data('matricule');
            var acronyme = $('.btn-prof.btn-primary').data('abreviation');
            var date = $("#date").val();

            if ((id > 0) && (matricule > 0)) {
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                        matricule: matricule,
                        id: id
                    },
                    function(resultat) {
                        switch (resultat) {
                            case '1':
                                // visualisation du changement pour la zone des RV
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                        acronyme: acronyme,
                                        date: date
                                    },
                                    function(resultat) {
                                        $("#listeRV").html(resultat);
                                    }
                                )
                                // régénérer la liste d'attente
                                $.post('inc/reunionParents/listeAttente.inc.php', {
                                    acronyme: acronyme,
                                    date: date,
                                    matricule: matricule,
                                    periode: perode
                                },
                                function(resultat){
                                    $("#listeAttenteProf").html(resultat);
                                }
                            )
                                break;
                            case '0':
                                alert("L'enregistrement s'est mal passé...")
                                break;
                            case '-1':
                                $("#modalMaxRV").modal('show');
                                break;
                            case '-2':
                                $("#modalDoublonRV").modal('show');
                                break;
                        }
                    }
                )
            }
        })

        // effacement d'un RV
        $("#listeRV").on('click', '.unlink', function() {
            var id = $(this).data('id');
            var eleve = $(this).data('eleve');
            var mail = $(this).data('mail');
            var acronyme = $('.btn-prof.btn-primary').data('abreviation');
            var date = $("#date").val();
            if (mail == '') {
                $.post('inc/reunionParents/delRV.inc.php', {
                        id: id
                    },
                    function(resultat) {
                        switch (resultat) {
                            case '1':
                                // visualisation du changement pour la zone des RV
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                        acronyme: acronyme,
                                        date: date,
                                    },
                                    function(resultat) {
                                        $("#listeRV").html(resultat);
                                    }
                                );
                                // régénérer la liste d'attente
                                $.post('inc/reunionParents/listeAttente.inc.php', {
                                    acronyme: acronyme,
                                    date: date,
                                    matricule: matricule,
                                    periode: perode
                                    },
                                    function(resultat){
                                        $("#listeAttenteProf").html(resultat);
                                    }
                                );
                                break;
                            case '0':
                                alert("Rien n'a été effacé")
                                break;
                        }
                    }
                )
            } else {
                $("#modalId").val(id);
                $("#modalNomEleve").html(eleve);
                $("#modalDelRV").modal('show');
            }
        })

        $(document).on('click', '#listeAttente', function() {
            var matricule = $('.btn-eleve.btn-primary').data('matricule');
            var acronyme = $('.btn-prof.btn-primary').data('abreviation');
            if (matricule !== undefined) {
                var date = $('#date').val();
                $('#attenteMatricule').val(matricule);
                $('#attenteAcronyme').val(acronyme);
                $('#modalAttente').modal('show');
            } else $("#modalElevePlz").modal('show');
        })

        // attribution d'un RV à un élève qui se trouve en liste d'attente
        $(document).on('click','.unlinkAttente', function() {

            var matricule = $(this).data('matricule');
            var acronyme = $(this).data('acronyme');
            var periode = $(this).data('periode');
            var id = $('.idRV:checked').val();
            var userName = $(this).data('userName');
            var date = $(this).data('date');
            var type = $("#type").val();

            if (id > 0) {
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                    matricule: matricule,
                    date: date,
                    acronyme: acronyme,
                    periode: periode,
                    userName: userName,
                    id: id
                    },
                    function(resultat){
                        switch (resultat) {
                            case '-1':
                                // le nombre max de RV est atteint
                                $("#modalMaxRV").modal('show');
                                break;
                            case '-2':
                                // il y a déjà un RV à cette heure-là
                                $("#modalDoublonRV").modal('show');
                                break;
                            default:
                                // si le mode est "adminEleves", il faut mettre à jour le "badge" et le "popover" des RV de l'élève
                                if (type == 'eleve') {
                                    // mise à jour du badge -nombre de RV- près du nom de l'élève
                                    var badge = parseInt($("#listeEleves").find('[data-matricule='+matricule+']').closest('li').find('.badge').text());
                                    $("#listeEleves").find('[data-matricule='+matricule+']').closest('li').find('.badge').text(badge+1);

                                    // Mise à jour du popover de la liste de RV
                                    $.post('inc/reunionParents/ulRvEleves.inc.php', {
                                            matricule: matricule,
                                            date: date
                                        },
                                        function(resultat) {
                                            var btnEleve = $("#listeEleves").find('[data-matricule=' + matricule + ']');
                                            btnEleve.attr('data-content', resultat).attr('data-placement', 'left');
                                            btnEleve.data('bs.popover').setContent();
                                        })
                                    }
                                // reconstruire la liste des RV mise à jour pour le prof désigné
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                            acronyme: acronyme,
                                            date: date
                                        },
                                        function(resultat) {
                                            $("#listeRV").html(resultat);
                                        }
                                    )
                                // reconstruire la liste d'attente
                                $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                                    date: date,
                                    acronyme: acronyme,
                                    matricule: matricule,
                                    periode: periode
                                }, function(resultat) {
                                    $("#listeAttenteProf").html(resultat);
                                });
                                break;
                            }
                        });
            }
            else $("#modalHeureRvPlz").modal('show');

        })

        // effacement de la liste d'attente
        $(document).on('click','.delAttente', function() {
            var matricule = $(this).data('matricule');
            var date = $(this).data('date');
            var acronyme = $(this).data('acronyme');
            var periode = $(this).data('periode');

            $.post('inc/reunionParents/delAttente.inc.php', {
                date: date,
                acronyme: acronyme,
                matricule: matricule,
                periode: periode
                },
            function (resultat){
                $("#listeAttenteProf").html(resultat);
            })
        })

    })
</script>
