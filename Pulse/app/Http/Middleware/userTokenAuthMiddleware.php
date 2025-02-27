<?php

namespace App\Http\Middleware;

use App\Models\Token;
use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class userTokenAuthMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $request["user"] = null;

        //Validate login
        try {
            if (!$request->cookie("access_token")) {
                return $this->unAuthorizeRequest();
            }

            //Validate token
            $user = null;
            $cookieToken = $request->cookie("access_token");
            $token = Token::getByToken($cookieToken);

            if (!$token) {
                return $this->unAuthorizeRequest();
            }

            if ($token->isExpired()) {
                return $this->unAuthorizeRequest("Expired token");
            }

            $user = User::getById($token->getUserId());
            if (!$user) {
                return $this->unAuthorizeRequest();
            }

            $request["user"] = $user;

            return $next($request);

        } catch (\Exception $err) {
            error_log("Error authorizing user: ". $err->getMessage());

            return $this->unAuthorizeRequest();
        }
    }

    private function unAuthorizeRequest($message = "Unauthorized") {
        return response()->json([
            "success" => false,
            "error" => $message
        ], 401);
    }
}
