import workzeug
from odoo import http
from odoo.http import request
from odoo.tools.translate import _
from odoo.addons.web.controllers.main import Session

class NRPSession(Session):
    @http.route('/web/session/authentication_with_mobile_app', type='json', auth='none')
    def authentication_with_mobile_app(self, db, employee_code = False, **kwg):
        ResUser = request.env['res.users'].sudo()
        if employee_code:
            search_users_result = ResUser.search([
                ['code', '=', employee_code]
            ])
            if len(search_users_result) == 1:
                login_email = search_users_result.login:
                request.session.authenticate(db, login_email, login_email)
                return request.env['ir.http'].session_info()
            else:
                return {
                    'error': _('Found users more than one')
                }
        else:
            return {
                'error': _('Not found employee code argument.')
            }