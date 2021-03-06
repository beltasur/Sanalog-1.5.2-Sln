﻿<%@ Page Title="" Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true"
    CodeFile="projects.aspx.cs" Inherits="admin_Projeler" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {

            $('body').on("click", ".table tr", function (e) {
                if (e.target.tagName == "TD") {
                    $("input[rel=Sec]").prop('checked', false);
                    $(this).closest('tr').find('input[rel=Sec]').prop('checked', 'checked');
                    $('.icon_duzenle').click();
                }
            });

            $('body').on("click", ".icon_sil", function () {
                if ($('input[rel=Sec]:checked').length < 1) {
                    bootbox.alert('Herhangi bir seçim yapmadınız.');
                    return;
                }

                bootbox.confirm("Silmek istediğinizden emin misiniz?", function (result) {
                    if (result != true)
                        return;

                    $('[name=HdnSil]').val('');
                    $('input[rel=Sec]:checked').each(function () {
                        $('[name=HdnSil]').val($('[name=HdnSil]').val() + $(this).val() + ',');
                    });
                    $('[name=HdnSil]').val($('[name=HdnSil]').val().substring(0, $('[name=HdnSil]').val().length - 1));
                    $('form').submit();
                });
            });

            $('body').on("change", "input[rel=TSec]", function () {
                $("input[rel=Sec]").prop('checked', $(this).is(':checked'));
            });

            $('body').on("click", ".icon_duzenle", function () {
                if ($('input[rel=Sec]:checked').length > 1)
                    bootbox.alert('Birden fazla seçim yaptınız. Lütfen 1 adet seçim yapınız.');
                else if ($('input[rel=Sec]:checked').length == 0)
                    bootbox.alert('Herhangi bir seçim yapmadınız.');
                else
                    window.location.href = "project-add.aspx?dil=<%= Snlg_ConfigValues.defaultLangId %>&projeid=" + $('input[rel=Sec]:checked:first').val();
            });

        });
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="Server">
    <cc1:ToolkitScriptManager runat="server">
    </cc1:ToolkitScriptManager>
    <script type="text/javascript" language="javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        function EndRequestHandler(sender, args) {
            $('.errors-in > div').remove();
            if (document.getElementById('<%= HdnHata.ClientID %>').value != "") {
                var hata = document.getElementById('<%= HdnHata.ClientID %>').value;
                var hataTur = document.getElementById('<%= HdnHataTur.ClientID %>').value;
                $('.errors-out').css('display', 'block');
                $('.errors-in').append('<div class="' + hataTur + '">' + hata + '</div>');
                document.getElementById('<%= HdnHata.ClientID %>').value = "";
                document.getElementById('<%= HdnHataTur.ClientID %>').value = "";
            }
        }
    </script>
    <div class="row projeler">
        <div class="col-md-12">
            <div class="page-head-x4"><%= Resources.admin_language.project_title %></div>
            <div class="page-head-x1"><%= Resources.admin_language.project_help %></div>
            <div class="row mb-md buttons" data-spy="affix" data-offset-top="150">
                <div class="col-md-12">
                    <a href="javascript:;" runat="server" id="sirala" visible="false" class="btn btn-warning icon_order" onclick="SnlgGdvSiralama();"><%= Resources.admin_language.icon_sorting %></a>
                    <a href="javascript:;" class="btn btn-warning icon_duzenle"><%= Resources.admin_language.edit %></a>
                    <a href="javascript:;" class="btn btn-danger icon_sil"><%= Resources.admin_language.delete %></a>
                    <a href="project-add.aspx" class="btn btn-success icon_yeni"><%= Resources.admin_language.add_new %></a>
                </div>
            </div>
            <div id="global_errors" class="errors-out">
                <div class="errors-in"></div>
            </div>
            <asp:HiddenField ID="HdnHata" runat="server" />
            <asp:HiddenField ID="HdnHataTur" runat="server" />
            <div class="panel">
                <div class="panel-heading"><%= Resources.admin_language.project_low_information %></div>
                <div class="panel-body">
                    <label style="display: block; margin-bottom: 5px; font-weight: bold;">
                        <%= Resources.admin_language.article_aspx_cat %></label>
                    <div class="pageSelect mb-lg">
                        <asp:DropDownList ID="DDLKtg" CssClass="form-control select1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLKtg_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <asp:GridView ID="GVIcerikler" class="table table-bordered table-striped" runat="server" AutoGenerateColumns="False" DataSourceID="SDSProjeler"
                        GridLines="None" AllowPaging="True" AllowSorting="True" DataKeyNames="ProjeId"
                        PageSize="30" OnDataBound="GVIcerikler_DataBound">
                        <Columns>
                            <asp:TemplateField ItemStyle-CssClass="secim" HeaderStyle-CssClass="secim">
                                <HeaderTemplate>
                                    <input rel="TSec" type="checkbox" title="Tümünü seç" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <input rel="Sec" type="checkbox" value="<%# Eval("ProjeId") %>" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Baslik" SortExpression="Baslik" HeaderText="<%$ Resources:admin_language, heading %>" ReadOnly="True" ItemStyle-CssClass="baslik" HeaderStyle-CssClass="baslik" />
                            <asp:BoundField DataField="ProjeUrl" HeaderText="<%$ Resources:admin_language, project_url %>" ReadOnly="True" ItemStyle-CssClass="url" />
                        </Columns>
                        <PagerTemplate>
                            <nav>
                                        <ul class="pagination" >
                                            <li><asp:LinkButton runat="server" ID="IlkPage" CommandName="First" aria-hidden="true" >&laquo;</asp:LinkButton></li>
                                            <li><asp:LinkButton runat="server" ID="geri" CommandName="Prev"   aria-hidden="true" >&#8249;</asp:LinkButton> </li>
                                            <asp:PlaceHolder ID="Sayfalama" runat="server" />
                                            <li><asp:LinkButton runat="server" ID="ileri"  CommandName="Next" aria-hidden="true" >&#8250;</asp:LinkButton></li>
                                            <li><asp:LinkButton runat="server" ID="SonPage" CommandName="Last"   aria-hidden="true" >&raquo;</asp:LinkButton></li>
                                        </ul>
                                  </nav>
                        </PagerTemplate>
                        <RowStyle CssClass="satir" />
                        <AlternatingRowStyle CssClass="aSatir" />
                        <EditRowStyle CssClass="eSatir" />
                        <SelectedRowStyle CssClass="seciliSatir" />

                        <HeaderStyle CssClass="baslikSatir" />
                        <SortedAscendingHeaderStyle CssClass="artan" />
                        <SortedDescendingHeaderStyle CssClass="azalan" />
                        <SortedAscendingCellStyle CssClass="artan" />
                        <SortedDescendingCellStyle CssClass="azalan" />
                    </asp:GridView>

                </div>
            </div>
            <asp:SqlDataSource ID="SDSProjeler" runat="server" ConnectionString="<%$ ConnectionStrings:e_cobiConn %>"
                SelectCommand="snlg_V1.msp_Projeler" SelectCommandType="StoredProcedure"
                CancelSelectOnNullParameter="False">
                <SelectParameters>
                    <asp:ControlParameter Name="KtgId" ControlID="DDLKtg" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

        </div>
    </div>
    <input type="hidden" name="HdnSil" />



    <div id="modalSnlgGdvSiralama" class="modal fade" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close icon_vazgec" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel"><%= Resources.admin_language.project_title %>  </h4>
                </div>
                <div class="modal-body" style="height: 600px;">
                    <div style="width: 100%; height: 100%;">
                        <asp:GridView ID="GrdSiralama" class="gdvSirala table table-bordered table-striped" runat="server"
                            AutoGenerateColumns="False"
                            DataKeyNames="ProjeId">
                            <Columns>
                                <asp:TemplateField ItemStyle-Width="30">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                        <input type="hidden" name="id" value='<%# Eval("ProjeId") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Baslik" SortExpression="Baslik" HeaderText="<%$ Resources:admin_language, heading %>" ReadOnly="True" ItemStyle-CssClass="baslik" HeaderStyle-CssClass="baslik" />
                                <asp:BoundField DataField="ProjeUrl" HeaderText="<%$ Resources:admin_language, project_url %>" ReadOnly="True" ItemStyle-CssClass="url" />
                            </Columns>
                            <RowStyle CssClass="satir" />
                            <AlternatingRowStyle CssClass="aSatir" />
                            <EditRowStyle CssClass="eSatir" />
                            <SelectedRowStyle CssClass="seciliSatir" />
                            <HeaderStyle CssClass="baslikSatir" />
                            <SortedAscendingHeaderStyle CssClass="artan" />
                            <SortedDescendingHeaderStyle CssClass="azalan" />
                            <SortedAscendingCellStyle CssClass="artan" />
                            <SortedDescendingCellStyle CssClass="azalan" />
                        </asp:GridView>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:LinkButton runat="server" ID="lnkBtnKaydet" Text="<%$ Resources:admin_language, save %>" class="btn btn-info icon_kaydet" OnClick="lnkBtnKaydet_Click"></asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
