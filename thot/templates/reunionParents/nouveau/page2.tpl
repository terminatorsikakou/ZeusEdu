<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="row">

    <div class="col-md-10 col-sm-12">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Détails de la réunion de parents</h3>
            </div>

             <div class="panel-body">
                {if ($date == '')}
                    <p class="alert alert-warning">Complétez d'abord la page 1</p>
                {/if}

            <form action="index.php" method="POST" role="form" class="form-inline">

            <div class="row">

                <div class="col-md-9 col-sm-12">
                    <div class="form-group">
                        <label for="Note">Note aux parents</label>
                        <textarea name="notice" rows="6" cols="80" class="form-control ckeditor" placeholder="Rédigez votre note aux parents ici">{$infoRp.generalites.notice|default:''}</textarea>
                        <p class="help-block">Notice destinée aux parents pour l'inscription à la réunion</p>
                    </div>
                </div>  <!-- col-md-... -->
                <div class="col-md-3 col-sm-12">
                    <div class="form-group">
                        <label for="activation">Activation</label>
                        <input type="checkbox" id="active" name="active" value="1"
                            {if isset($infoRp.generalites.active) && ($infoRp.generalites.active==1)}checked{/if}
                            {if ($date== '')} disabled{/if}>
                        <p class="help-block">La réunion de parents est-elle activée</p>
                    </div>

                    <div class="form-group">
                        <label for="activation">Ouverture</label>
                        <input type="checkbox" id="ouvert" name="ouvert" value="1"
                        {if isset($infoRp.generalites.ouvert) && ($infoRp.generalites.ouvert==1)}checked{/if}
                        {if ($date == '')} disabled{/if}>
                        <p class="help-block">La réunion de parents est-elle ouverte à l'inscription</p>
                    </div>

                    <fieldset {if ($date == '')}disabled{/if}>
                        <legend>Listes d'attente</legend>
                        <table class="table table-condensed">
                            <tr>
                                <td>1</td>
                                <td><input
                                    type="text"
                                    class="form-control"
                                    size="3"
                                    name="minPer1"
                                    value="{$infoRp.heures.minPer1|default:$infoRp.heuresLimites.min|default:''}" readonly>
                                </td>
                                <td>
                                    <input
                                    type="text"
                                    class="heure form-control"
                                    size="3"
                                    name="maxPer1" id="maxPer1"
                                    value="{$infoRp.heures.maxPer1|default:$infoRp.heuresLimites.min|default:''}"></td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td><input
                                    type="text"
                                    class="form-control"
                                    size="3"
                                    name="minPer2" id="minPer2"
                                    value="{$infoRp.heures.minPer2|default:$infoRp.heuresLimites.min|default:''}" readonly></td>
                                <td><input
                                    type="text"
                                    class="form-control"
                                    size="3"
                                    name="maxPer2" id="maxPer2"
                                    value="{$infoRp.heures.maxPer2|default:$infoRp.heuresLimites.max|default:''}" readonly></td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td><input
                                    type="text"
                                    class="heure form-control"
                                    size="3"
                                    name="minPer3" id="minPer3"
                                    value="{$infoRp.heures.minPer3|default:$infoRp.heuresLimites.max|default:''}"></td>
                                <td><input
                                    type="text"
                                    class="form-control"
                                    size="3"
                                    name="maxPer3"
                                    value="{$infoRp.heures.maxPer3|default:$infoRp.heuresLimites.max|default:''}" readonly></td>
                            </tr>
                        </table>

                    </fieldset>

                    <div class="btn-group-vertical pull-right">
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                        <button type="reset" class="btn btn-default">Annuler</button>
                    </div>

                    <input type="hidden" name="date" value="{$date|default:''}">
                    <input type="hidden" name="action" value="{$action}">
                    <input type="hidden" name="mode" value="enregistrer">
                    <input type="hidden" name="etape" value="etape2">

                </div>

            </div>  <!-- row -->

              </form>

          </div>
          <div class="panel-footer">

          </div>
        </div>


    </div>

    <div class="col-md-2 col-sm-12">

        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">Informations</h3>
          </div>
          <div class="panel-body">
            <h4>Note aux parents</h4>
            <p class="micro">Informations affichées aux parents qui s'inscrivent.</p>
            <h4>Activation</h4>
            <p class="micro">Visible par les parents (mais pas d'inscription possible).</p>
            <h4>Ouverture</h4>
            <p class="micro">Inscription des parents possible.</p>
            <h4>Listes d'attente</h4>
            <p class="micro">Les parents qui n'ont pu s'inscrire faute de place sont invités à indiquer une période durant laquelle il peuvent accepter un rendez-vous si une place se libère.</p>

          </div>
          <div class="panel-footer">

          </div>

        </div>

    </div>

</div>
